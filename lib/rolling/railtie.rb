module Rolling
  class Railtie < Rails::Railtie
    initializer "rolling.initialization" do
      config.before_initialize do
        roles_yaml = YAML.load_file(Rails.root.join('config/', Rolling.roles_file)).deep_symbolize_keys
        Rolling.roles = roles_yaml.map { |k,v| [k, Rolling::Model::PermittedConfiguration.from_hash(k, v)] }.to_h
      end
    end
  end
end
