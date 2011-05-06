# GroupDataImporter
#
# ==> Category.csv <==
# id,name,depth,group_id,creator_id,description
#
# ==> Example.csv <==
# id,name,ling_id,group_id,creator_id
#
# ==> ExampleLingsProperty.csv <===
# id,example_id,lings_property_id,group_id,creator_id
#
# ==> Group.csv <==
# id, name, privacy, depth_maximum, ling0_name, ling1_name, property_name, category_name, lings_property_name, example_name, examples_lings_property_name, example_fields
#
# ==> Ling.csv <==
# id,name,parent_id,depth,group_id,creator_id
#
# ==> LingsProperty.csv <==
# id,ling_id,property_id,value,group_id,creator_id
#
# ==> Membership.csv <==
# id,member_id,group_id,level,creator_id
#
# ==> Property.csv <==
# id,name,description,category,group_id,creator_id
#
# ===> StoredValue.csv <=====
# id, storable_id, storable_type, key, value, group_id
#
# ==> User.csv <==
# id,name,email,access_level,password
#

module GroupData
  class Importer

    class << self
      def import(path)
        importer = new(path)
        importer.import!
        importer
      end
    end

    attr_accessor :config

    # accepts path to yaml file containing paths to csvs
    def initialize(path)
      @path = path
      @config = YAML.load_file(@path)
      @config.symbolize_keys!
    end

    def import!
      CSV.foreach(@config[:group], :headers => true) do |row|
        group = Group.find_or_create_by_name(row["name"])
        Group::CSV_ATTRIBUTES.each do |attribute|
          next if attribute =~ /id$/
          group.send("#{attribute}=", row[attribute])
        end
        group.save!
      end
    end
  end

end