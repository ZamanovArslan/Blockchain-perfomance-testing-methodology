require "ethereum.rb"
require "optparse"
require "byebug"
require "./thread_pool"
require 'concurrent'

def test_case(contract)
  contract.deploy
  puts "\n Contract Deployed"
rescue Exception => e
  puts e.to_s
end

options = {}

OptionParser.new do |opts|
  opts.on("-n", "--nodes=NODES", "Nodes urls") do |nodes|
    options.merge!(nodes: nodes.split(" "))
  end

  opts.on("-r", "--requests=REQUESTS", "Count of requests") do |requests_count|
    options.merge!(requests_count: requests_count.to_i)
  end

  opts.on("-c", "--contract=PATH", "Contract Path") do |contract_path|
    options.merge!(contract_path: contract_path)
  end

  opts.on("-a", "--account=ACCOUNT", "Account key") do |account|
    options.merge!(account: account)
  end

  opts.on("-t", "--threads[=THREADS]", "Threads") do |threads|
    options.merge!(threads: threads)
  end
end.parse!(ARGV)

options[:threads] = options[:threads] || 1

contracts = options[:nodes].map do |node|
  client = Ethereum::HttpClient.new(node)
  client.default_account = options[:account]
  contract = Ethereum::Contract.create(client: client, file: options[:contract_path])
end

pool = Concurrent::FixedThreadPool.new(options[:threads], auto_terminate: true)
options[:requests_count].times do
  pool.post { test_case(contracts.sample) }
end

pool.shutdown
pool.wait_for_termination
