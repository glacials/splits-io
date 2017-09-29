options = {
  region: ENV['AWS_REGION'],
  credentials: Aws::Credentials.new(
    ENV['AWS_ACCESS_KEY_ID'],
    ENV['AWS_SECRET_KEY']
  )
}

if ENV['AWS_REGION'] == 'local'
  options.merge!(endpoint: 'http://dynamodb:8000')
end

$dynamodb_run_histories_table_name = 'run_histories'

$dynamodb_client = Aws::DynamoDB::Client.new(options)

if !$dynamodb_client.list_tables.table_names.include?($dynamodb_run_histories_table_name)
  $dynamodb_client.create_table(
    table_name: $dynamodb_run_histories_table_name,
    key_schema: [
      {
        attribute_name: 'run_id',
        key_type: 'HASH'
      },
      {
        attribute_name: 'attempt_number',
        key_type: 'RANGE'
      }
    ],
    attribute_definitions: [
      {
        attribute_name: 'run_id',
        attribute_type: 'S'
      },
      {
        attribute_name: 'attempt_number',
        attribute_type: 'N'
      }
    ],
    provisioned_throughput: {
      read_capacity_units: 5,
      write_capacity_units: 5
    }
  )
end

$dynamodb_run_histories = Aws::DynamoDB::Table.new(
  $dynamodb_run_histories_table_name,
  client: $dynamodb_client
)
