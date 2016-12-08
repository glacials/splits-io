options = {
  region: ENV['AWS_REGION'],
  credentials: Aws::Credentials.new(
    ENV['AWS_ACCESS_KEY_ID'],
    ENV['AWS_SECRET_KEY']
  )
}

if ENV['AWS_REGION'] == 'local'
  options.merge!(endpoint: 'http://localhost:8000')
end

$dynamodb_client = Aws::DynamoDB::Client.new(options)

if !$dynamodb_client.list_tables.table_names.include?('splits')
  $dynamodb_client.create_table(
    table_name: 'splits',
    key_schema: [
      {
        attribute_name: 'id',
        key_type: 'HASH'
      }
    ],
    attribute_definitions: [
      {
        attribute_name: 'id',
        attribute_type: 'S'
      }
    ],
    provisioned_throughput: {
      read_capacity_units: 5,
      write_capacity_units: 5
    }
  )
end

if !$dynamodb_client.list_tables.table_names.include?('users')
  $dynamodb_client.create_table(
    table_name: 'users',
    key_schema: [
      {
        attribute_name: 'id',
        key_type: 'HASH'
      }
    ],
    attribute_definitions: [
      {
        attribute_name: 'id',
        attribute_type: 'S'
      }
    ],
    provisioned_throughput: {
      read_capacity_units: 5,
      write_capacity_units: 5
    }
  )
end

if !$dynamodb_client.list_tables.table_names.include?('patreon_users')
  $dynamodb_client.create_table(
    table_name: 'patreon_users',
    key_schema: [
      {
        attribute_name: 'user_id',
        key_type: 'HASH'
      }
    ],
    attribute_definitions: [
      {
        attribute_name: 'user_id',
        attribute_type: 'S'
      }
    ],
    provisioned_throughput: {
      read_capacity_units: 5,
      write_capacity_units: 5
    }
  )
end

$dynamodb_splits = Aws::DynamoDB::Table.new('splits', client: $dynamodb_client)
$dynamodb_users = Aws::DynamoDB::Table.new('users', client: $dynamodb_client)
$dynamodb_patreon_users = Aws::DynamoDB::Table.new('patreon_users', client: $dynamodb_client)
