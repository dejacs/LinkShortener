platform :ios, '13.0'

use_frameworks!

workspace 'LinkShortener'

# network_module
def network_pods
    # some pod
end

target 'NetworkCore' do
  project 'NetworkCore/NetworkCore.project'
  network_pods
end


# application
def application_pods
    network_pods
end

target 'LinkShortener' do
  project 'LinkShortener.project'
  application_pods

  target 'LinkShortenerTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'LinkShortenerUITests' do
    # Pods for testing
  end
end