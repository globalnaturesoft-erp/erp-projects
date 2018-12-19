module Erp::Projects
  class Category < ApplicationRecord
    include Erp::CustomOrder
		
    belongs_to :creator, class_name: "Erp::User"
    belongs_to :parent, class_name: "Erp::Projects::Category", optional: true
    has_many :children, class_name: "Erp::Projects::Category", foreign_key: "parent_id"
    has_many :articles, class_name: "Erp::Projects::Projects"
    validates :name, :presence => true
    
    # class const
    STATUS_ACTIVE = 'active'
    STATUS_DELETED = 'deleted'
    
    # get active
    def self.get_active
			self.where(status: self::STATUS_ACTIVE)
		end
    
    # Filters
    def self.filter(query, params)
      params = params.to_unsafe_hash
      and_conds = []
			
			#filters
			if params["filters"].present?
				params["filters"].each do |ft|
					or_conds = []
					ft[1].each do |cond|
						or_conds << "#{cond[1]["name"]} = '#{cond[1]["value"]}'"
					end
					and_conds << '('+or_conds.join(' OR ')+')' if !or_conds.empty?
				end
			end
      
      #keywords
      if params["keywords"].present?
        params["keywords"].each do |kw|
          or_conds = []
          kw[1].each do |cond|
            or_conds << "LOWER(#{cond[1]["name"]}) LIKE '%#{cond[1]["value"].downcase.strip}%'"
          end
          and_conds << '('+or_conds.join(' OR ')+')'
        end
      end
      
      # join with users table for search creator
      #query = query.joins("LEFT JOIN erp_articles_categories parents_erp_articles_categories ON parents_erp_articles_categories.id = erp_articles_categories.parent_id")

      query = query.where(and_conds.join(' AND ')) if !and_conds.empty?
      
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
      end
      
      return query
    end
    
    # data for dataselect ajax
    def self.dataselect(keyword='')
      query = self.all
      
      if keyword.present?
        keyword = keyword.strip.downcase
        query = query.where('LOWER(name) LIKE ?', "%#{keyword}%")
      end
      
      query = query.limit(20).map{|category| {value: category.id, text: category.name} }
    end
    
    # display name
    def parent_name
			parent.present? ? parent.name : ''
		end
		
		# display name with parent
    def full_name
			names = [self.name]
			p = self.parent
			while !p.nil? do
				names << p.name
				p = p.parent
			end
			names.reverse.join(" / ")
		end
  end
end