Dummy::Application.routes.draw do
  root :to => "welcome#index"
  match '/javascript_test', :to => "welcome#javascript_test"
end
