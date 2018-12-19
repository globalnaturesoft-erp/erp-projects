Erp::Projects::Engine.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :backend, module: "backend", path: "backend/projects" do
      resources :projects do
        collection do
          post 'list'
        end
      end
      resources :project_images do
				collection do
					get 'form_line'
				end
			end
      resources :categories do
        collection do
          post 'list'
          get 'dataselect'
          put 'move_up'
          put 'move_down'
        end
      end
    end
  end
end