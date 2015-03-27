module Specroutes
  class ResourceTree
    class Error < ::StandardError; end
    class DoesNotFitError < Error; end

    WITHOUT_LAST_SLASH_RE = %r{/(?=[^/])}

    attr_reader :payload, :path_portion, :parent, :children, :meta_data

    def self.from_resource_list(resources)
      root_node = ResourceTree.new('/')
      resources.sort_by(&:path).each do |resource|
        root_node.branch!(resource.path, resource)
      end
      root_node
    end

    def initialize(path_portion, parent=nil, meta=nil)
      @path_portion = path_portion
      @payload = []
      @children = []
      @meta_data = Array(meta).flatten
      @parent = parent
      parent.register(self) if parent
    end

    def register(node)
      children << node
      node
    end

    def path
      @path or path!
    end

    def path!
      @path = "#{parent && parent.path}#{path_portion}"
    end

    def depth
      @depth or depth!
    end

    def depth!
      @depth = parent ? parent.depth + 1 : 0
    end

    def branch!(resource_path, resource)
      if resource_path.start_with?(path)
        reduced_path = resource_path.sub(path, '')
        portions_with_meta = metafied_portions(reduced_path, resource)
        node = portions_with_meta.reduce(self) { |n, p| n.child_for!(p, n) }
        node.payload << resource
      else
        branch_from_parent!(resource_path, resource)
      end
    end

    def metafied_portions(reduced_path, resource)
      if resource_partionable?(resource)
        part_path = resource.resource_part_stack.map { |p| p.path }.join
        part_path = part_path.sub(path, '')
        id_path_part = reduced_path.sub("#{part_path}/", '').
          split(WITHOUT_LAST_SLASH_RE)
        part_path_part = resource.resource_part_stack.map do |part|
          [part.clean_path, part.meta]
        end
        part_path_part + id_path_part
      else
        reduced_path.split(WITHOUT_LAST_SLASH_RE)
      end
    end

    def branch_from_parent!(resource_path, resource)
      if parent
        parent.branch!(resource_path, resource)
      else
        raise DoesNotFitError.new("#{resource_path} does not fit.")
      end
    end

    def child_for!(combined_portion, node)
      portion, meta = combined_portion
      child = children.find { |c| c.path_portion == portion }
      child or ResourceTree.new(portion, node, meta)
    end

    def each_node(&block)
      if block_given?
        block.call(self) if parent
        children.each { |c| c.each_node(&block) }
      end
    end

    private
    def resource_partionable?(resource)
      resource.respond_to?(:resource_part_stack) &&
        resource.resource_part_stack.any?
    end
  end
end
