module Erp::Projects
  class Project < ApplicationRecord
    belongs_to :creator, class_name: "Erp::User"
    belongs_to :category, class_name: "Erp::Projects::Category", foreign_key: :category_id
    #belongs_to :customer, class_name: "Erp::Contacts::Contact", foreign_key: :customer_id
    
    mount_uploader :image, Erp::Projects::ProjectUploader
    
    has_many :project_images, dependent: :destroy
    accepts_nested_attributes_for :project_images, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
    
    #validates :code, uniqueness: true
    validates :name, presence: true
    
    # Filters
    def self.filter(query, params)
      params = params.to_unsafe_hash

      # join with users table for search creator
      query = query.joins(:creator)

      and_conds = []

      # filters
      if params["filters"].present?
        params["filters"].each do |ft|
          or_conds = []
          ft[1].each do |cond|
            or_conds << "#{cond[1]["name"]} = '#{cond[1]["value"]}'"
          end
          and_conds << '('+or_conds.join(' OR ')+')' if !or_conds.empty?
        end
      end

      # keywords
      if params["keywords"].present?
        params["keywords"].each do |kw|
          or_conds = []
          kw[1].each do |cond|
            or_conds << "LOWER(#{cond[1]["name"]}) LIKE '%#{cond[1]["value"].downcase.strip}%'"
          end
          and_conds << '('+or_conds.join(' OR ')+')'
        end
      end

      # add conditions to query
      query = query.where(and_conds.join(' AND ')) if !and_conds.empty?

      # single keyword
      if params[:keyword].present?
				keyword = params[:keyword].strip.downcase
				keyword.split(' ').each do |q|
					q = q.strip
					query = query.where('LOWER(erp_projects_projects.name) LIKE ?', '%'+q+'%')
				end
			end

      return query
    end

    def self.search(params)
      query = self.all
      query = self.filter(query, params)

      # order
      if params[:sort_by].present?
        order = params[:sort_by]
        order += " #{params[:sort_direction]}" if params[:sort_direction].present?

        query = query.order(order)
      else
				query = query.order('erp_projects_projects.created_at DESC')
      end

      return query
    end

    # data for dataselect ajax
    def self.dataselect(keyword='', params={})
			query = self.all

      if keyword.present?
        keyword = keyword.strip.downcase
        query = query.where('LOWER(name) LIKE ?', "%#{keyword}%")
      end

      query = query.order("erp_projects_projects.start_date DESC").limit(8).map{|project| {value: project.id, text: project.name} }

			return query
    end
    
    def category_name
      category.present? ? category.name : ''
    end
    
    # get all active
    def self.get_active
      self.all
    end
    
    # get newest projects
    def self.newest_projects(limit=nil)
			self.get_active.order('erp_projects_projects.created_at DESC').limit(limit)
		end
  end
end
