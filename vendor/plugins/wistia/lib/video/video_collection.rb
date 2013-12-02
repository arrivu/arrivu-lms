module VideoCollection

  class Collection
    def initialize(id, hash_id, name, description, mediaCount, medias=nil)
      @id = id
      @hash_id = hash_id
      @name    = name
      @description = description
      @mediaCount = mediaCount
      @medias =   medias

      def medias(medias)
        @medias = medias
      end

    end
  end

  class Media
    def initialize(id, hash_id, name, description, embed_code,
        thumbnail_url, thumbnail_height, thumbnail_width)
      @id = id
      @hash_id = hash_id
      @name    = name
      @description = description
      @embed_code = embed_code
      @thumbnail_url =   thumbnail_url
      @thumbnail_height =   thumbnail_height
      @thumbnail_width =   thumbnail_width
    end
  end
end

