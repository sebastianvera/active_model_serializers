module ActiveModel
  class Serializer
    class ArraySerializer
      include Enumerable
      delegate :each, to: :@objects

      attr_reader :meta, :meta_key, :root

      def initialize(objects, options = {})
        @root = options.fetch(:root, nil)
        options.merge!(root: nil)

        @objects = objects.map do |object|
          serializer_class = options.fetch(
            :serializer,
            ActiveModel::Serializer.serializer_for(object)
          )
          serializer_class.new(object, options)
        end
        @meta     = options[:meta]
        @meta_key = options[:meta_key]
      end

      def json_key
        if @root.present?
          @root
        else
          @objects.first.json_key if @objects.first
        end
      end

      def root=(root)
        @objects.first.root = root if @root.blank? && @objects.first
      end
    end
  end
end
