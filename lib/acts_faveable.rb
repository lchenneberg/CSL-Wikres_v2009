module Wikres
  module Acts
    module Faveable

      module ControllerExtension
        def self.included(base)
          base.extend ClassMethods
        end

        module ClassMethods
          def acts_as_faveable
            has_many :favorites, :as => :faveable, :dependent => :destroy, :order => "created_at, faveable_type DESC"
            include Wikres::Acts::Faveable::ControllerExtension::InstanceMethods
            extend Wikres::Acts::Faveable::ControllerExtension::SingletonMethods
          end
        end

        module SingletonMethods

        end

        module InstanceMethods
          def find_favorites_by_type(type)
            self.favorites.find_all_by_faveable_type(type)
          end

          def add_to_favorites
            
          end
        end
        
      end

      module ModelExtension
        def self.included(base)
          base.extend ClassMethods
        end

        module ClassMethods
          include Wikres::Acts::Faveable::ModelExtension::InstanceMethods
          extend Wikres::Acts::Faveable::ModelExtension::SingletonMethods
        end

        module SingletonMethods

        end

        module InstanceMethods
          
        end
        
      end

      module UserExtension
        def self.included(base)
          base.extend ClassMethods
        end

        module ClassMethods
          include Wikres::Acts::Faveable::UserExtension::InstanceMethods
          extend Wikres::Acts::Faveable::UserExtension::SingletonMethods
        end

        module SingletonMethods

        end

        module InstanceMethods

        end
      end

    end
  end
end

ActiveRecord::Base.send(:include,Wikres::Acts::Faveable::ModelExtension)
ActionController::Base.send(:include,Wikres::Acts::Faveable::ControllerExtension)