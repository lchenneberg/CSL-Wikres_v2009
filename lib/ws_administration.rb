module WsAdministration
  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    def ws_admin(options = {})
      options.assert_valid_keys(:list_add_cols)
      cattr_accessor :list_added_cols

      self.list_added_cols = options[:list_add_cols]
      send :include, InstanceMethods
    end
  end

  module InstanceMethods
    def get_columns
    end

    def ws_admin
    end

    def list_extra_cols
      [:id] + self.list_added_cols
    end

    def list_cols_names
    end

    def list_extra_cols_names
      names = []
      list = [:id] + self.list_added_cols
      for symb in list
        names << symb.to_s.humanize.capitalize
      end
      names
    end
  end
end

ActiveRecord::Base.send :include, WsAdministration