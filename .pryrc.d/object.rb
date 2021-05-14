class Object

  private

  def pbpaste
    `pbpaste`
  end

  def pbjson(obj)
    options = {
      indent: 2,
      index: false,
      multiline: true,
      plain: true,
      object_id: false,
      sort_keys: false,
      sort_vars: false,
      ruby19_syntax: true
    }
    doc = begin
      obj.ai(options).gsub(/^#<[^>]+>\s+/, '')
    end

    IO.popen('pbcopy', 'w') { |io| io << doc }
  end

  def sqlon
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end

  def sqloff
    ActiveRecord::Base.logger = nil
  end

  def sql(query)
    ActiveRecord::Base.connection.select_all(query)
  end

  def tp(arr, markdown: false)
    headers = arr.kind_of?(Hash) ? { 0 => 'Key', 1 => 'Value' } : nil
    puts Hirb::Helpers::AutoTable.render(arr, markdown: markdown, width: 240, headers: headers)
  end

  def vtp(arr, hide_empty: false, markdown: false)
    puts Hirb::Helpers::VerticalTable.render(arr, hide_empty: hide_empty, markdown: markdown)
  end
end

# def unstaged
#   realm  = Qbo::Realm.last
#   query  = Qbo::RealmEntities.new(realm)
#   results = query.not_staged

#   carrier_contracts = results[:carriers].map do |entity|
#       Qbo::Schemas::EntitySchema.call( entity.as_json.symbolize_keys )
#   end.partition do |entity|
#     entity.success?
#   end

#   # Contract = Dry::Validation.Schema do
#   #   each do
#   #     schema(Qbo::Schemas::EntitySchema)
#   #   end
#   # end

#   results = Contract.call(results[:shippers])

#   shipper_contracts = results[:shippers].map do |entity|
#       Qbo::Schemas::EntitySchema.call( entity.as_json.symbolize_keys )
#   end.partition do |entity|
#     entity.success?
#   end

#   carrier_params = carrier_contracts[0].map(&:to_hash)
#   shipper_params = shipper_contracts[0].map(&:to_hash)

#   {
#     realm: realm,
#     query: query,
#     results: results,
#     carrier_contracts: carrier_contracts,
#     shipper_contracts: shipper_contracts,
#     carrier_params: carrier_params,
#     shipper_params: shipper_params,
#     carrier_entities: realm.entities.build(carrier_params),
#     shipper_entities: realm.entities.build(shipper_params),
#   }
# end

def shipper_create
  vendor_hash = Qbo::Representer::ShipperRepresenter.new(shipper_qbo_twin).to_hash
  vendor      = Qbo::Entities::Vendor.new(vendor_hash)
end

def shipper_qbo_twin
  shipper = Shipper.find 46
  Qbo::Decorator::ShipperTwin.new(shipper)
end

def shipper_qbo_representer
  Qbo::Representer::ShipperRepresenter.new(shipper_qbo_twin).to_hash
end
