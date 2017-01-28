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

if !$dynamodb_client.list_tables.table_names.include?('run_histories')
  $dynamodb_client.create_table(
    table_name: 'run_histories',
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

if !$dynamodb_client.list_tables.table_names.include?('segments')
  $dynamodb_client.create_table(
    table_name: 'segments',
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

if !$dynamodb_client.list_tables.table_names.include?('segment_histories')
  $dynamodb_client.create_table(
    table_name: 'segment_histories',
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

$dynamodb_runs = Aws::DynamoDB::Table.new('splits', client: $dynamodb_client)
$dynamodb_run_histories = Aws::DynamoDB::Table.new('run_histories', client: $dynamodb_client)
$dynamodb_users = Aws::DynamoDB::Table.new('users', client: $dynamodb_client)
$dynamodb_patreon_users = Aws::DynamoDB::Table.new('patreon_users', client: $dynamodb_client)
$dynamodb_segments = Aws::DynamoDB::Table.new('segments_v1', client: $dynamodb_client)
$dynamodb_segment_histories = Aws::DynamoDB::Table.new('segment_histories', client: $dynamodb_client)
