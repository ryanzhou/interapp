Interapp::Engine.routes.draw do
  post "/" => "messages#create", as: :root
end
