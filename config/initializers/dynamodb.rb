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

$dynamodb_runs_table_name = 'splits'
$dynamodb_run_histories_table_name = 'run_histories'
$dynamodb_users_table_name = 'users'
$dynamodb_patreon_users_table_name = 'patreon_users'
$dynamodb_segments_table_name = 'segments_v1'
$dynamodb_segment_histories_table_name = 'segment_histories'

$dynamodb_client = Aws::DynamoDB::Client.new(options)

if !$dynamodb_client.list_tables.table_names.include?($dynamodb_runs_table_name)
  $dynamodb_client.create_table(
    table_name: $dynamodb_runs_table_name,
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

if !$dynamodb_client.list_tables.table_names.include?($dynamodb_users_table_name)
  $dynamodb_client.create_table(
    table_name: $dynamodb_users_table_name,
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

if !$dynamodb_client.list_tables.table_names.include?($dynamodb_patreon_users_table_name)
  $dynamodb_client.create_table(
    table_name: $dynamodb_patreon_users_table_name,
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

if !$dynamodb_client.list_tables.table_names.include?($dynamodb_segments_table_name)
  $dynamodb_client.create_table(
    table_name: $dynamodb_segments_table_name,
    key_schema: [
      {
        attribute_name: 'run_id',
        key_type: 'HASH'
      },
      {
        attribute_name: 'segment_number',
        key_type: 'RANGE'
      }
    ],
    attribute_definitions: [
      {
        attribute_name: 'run_id',
        attribute_type: 'S'
      },
      {
        attribute_name: 'segment_number',
        attribute_type: 'N'
      }
    ],
    provisioned_throughput: {
      read_capacity_units: 5,
      write_capacity_units: 5
    }
  )
end

if !$dynamodb_client.list_tables.table_names.include?($dynamodb_segment_histories_table_name)
  $dynamodb_client.create_table(
    table_name: $dynamodb_segment_histories_table_name,
    key_schema: [
      {
        attribute_name: 'segment_id',
        key_type: 'HASH'
      },
      {
        attribute_name: 'attempt_number',
        key_type: 'RANGE'
      }
    ],
    attribute_definitions: [
      {
        attribute_name: 'segment_id',
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

$dynamodb_runs = Aws::DynamoDB::Table.new(
  $dynamodb_runs_table_name,
  client: $dynamodb_client
)
$dynamodb_run_histories = Aws::DynamoDB::Table.new(
  $dynamodb_run_histories_table_name,
  client: $dynamodb_client
)
$dynamodb_users = Aws::DynamoDB::Table.new(
  $dynamodb_users_table_name,
  client: $dynamodb_client
)
$dynamodb_patreon_users = Aws::DynamoDB::Table.new(
  $dynamodb_patreon_users_table_name,
  client: $dynamodb_client
)
$dynamodb_segments = Aws::DynamoDB::Table.new(
  $dynamodb_segments_table_name,
  client: $dynamodb_client
)
$dynamodb_segment_histories = Aws::DynamoDB::Table.new(
  $dynamodb_segment_histories_table_name,
  client: $dynamodb_client
)
