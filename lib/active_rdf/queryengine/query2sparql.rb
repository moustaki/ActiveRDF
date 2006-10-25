# translates abstract query into SPARQL that can be executed on SPARQL-compliant data source
#
# Author:: Eyal Oren
# Copyright:: (c) 2005-2006
# License:: LGPL
require 'active_rdf'


class Query2SPARQL
  def self.translate(query)
    str = ""
    if query.select?
      distinct = query.distinct? ? "DISTINCT " : ""
			select_clauses = query.select_clauses.collect{|s| construct_clause(s)}

      str << "SELECT #{distinct}#{select_clauses.join(' ')} "
      str << "WHERE { #{where_clauses(query)} }"
    elsif query.ask?
      str << "ASK { #{where_clauses(query)} }"
    end
    
    $log.debug "Query2SPARQL: translated the query to #{str}"
    return str
  end

  private
  # concatenate each where clause using space (e.g. 's p o')
  # and concatenate the clauses using dot, e.g. 's p o . s2 p2 o2 .'
  def self.where_clauses(query)
		where_clauses = query.where_clauses.collect do |triple|
			triple.collect {|term| construct_clause(term)}.join(' ')
		end
    "#{where_clauses.join('. ')} ."
  end

	def self.construct_clause(term)
		case term
		when Symbol
			'?' + term.to_s
		when RDFS::Resource
			'<' + term.uri + '>'
		else
			term.to_s
		end
	end
end