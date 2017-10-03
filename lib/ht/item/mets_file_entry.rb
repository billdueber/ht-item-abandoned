require 'dry-struct'


module HT
  class Item

    module Types
      include Dry::Types.module
    end

    class MetsFileEntry < Dry::Struct

      SuffixMap = {
        'text/plain' => 'txt',
        'text/xml'   => 'xml',
        'image/jp2'  => 'jp2'
      }


      MimeTypes = Types::Strict::String.enum(*(SuffixMap.keys))

      attribute :id, Types::Strict::String
      attribute :size, Types::Form::Int
      attribute :sequence, Types::Form::Int
      attribute :mimetype, MimeTypes
      attribute :created, Types::Form::DateTime
      attribute :checksum, Types::Strict::String
      attribute :sequenceString, Types::Strict::String

      def suffix
        SuffixMap[mimetype]
      end

      def zipfilepath
        "/#{sequenceString}.#{suffix}"
      end

    end
  end
end
