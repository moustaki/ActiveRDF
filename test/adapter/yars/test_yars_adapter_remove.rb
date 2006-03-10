# = test_yars_adapter_remove.rb
#
# Unit Test of Yars adapter remove method
#
# == Project
#
# * ActiveRDF
# <http://m3pe.org/activerdf/>
#
# == Authors
# 
# * Eyal Oren <first dot last at deri dot org>
# * Renaud Delbru <first dot last at deri dot org>
#
# == Copyright
#
# (c) 2005-2006 by Eyal Oren and Renaud Delbru - All Rights Reserved
#
# == To-do
#
# * TODO: See again the remove test with nil, I think it'is allowed in redland.
#

require 'test/unit'
require 'active_rdf'
require 'adapter/yars/yars_adapter'

class TestYarsAdapterRemove < Test::Unit::TestCase

	@@adapter = nil

	def setup		
		params = { :adapter => :yars, :host => 'opteron', :port => 8080, :context => 'test_remove2' }
		@@adapter = NodeFactory.connection(params) if @@adapter.nil?
	end
	
	def test_A_remove_triples_error_object_not_node
		
		subject = NodeFactory.create_basic_identified_resource('http://m3pe.org/subject')
		predicate = NodeFactory.create_basic_identified_resource('http://m3pe.org/predicate')
		
		assert_raise(StatementRemoveYarsError) {
			@@adapter.remove(subject, predicate, 'test')
		}
	end
	
	def test_B_remove_triples_error_predicate_not_resource
		
		subject = NodeFactory.create_basic_identified_resource('http://m3pe.org/subject')
		object = NodeFactory.create_basic_identified_resource('http://m3pe.org/object')
		
		assert_raise(StatementRemoveYarsError) {
			@@adapter.remove(subject, 'test', object)
		}
	end
	
	def test_C_remove_triples_error_subject_not_resource
		
		object = NodeFactory.create_basic_identified_resource('http://m3pe.org/object')
		predicate = NodeFactory.create_basic_identified_resource('http://m3pe.org/predicate')
		
		assert_raise(StatementRemoveYarsError) {
			@@adapter.remove('test', predicate, object)
		}
	end
	
	def test_D_remove_triples_triple_dont_exist
		
		subject = NodeFactory.create_basic_identified_resource('http://m3pe.org/subject')
		predicate = NodeFactory.create_basic_identified_resource('http://m3pe.org/predicate')
		object = NodeFactory.create_literal('42', 'xsd:integer')
		
		assert_nothing_raised(StatementRemoveYarsError) {
			@@adapter.remove(subject, predicate, object)
		}
	end
	
	def test_E_remove_triples_object_literal
		
		subject = NodeFactory.create_basic_identified_resource('http://m3pe.org/subject')
		predicate = NodeFactory.create_basic_identified_resource('http://m3pe.org/predicate')
		object = NodeFactory.create_literal('42', 'xsd:integer')

		@@adapter.add(subject, predicate, object)

		assert_nothing_raised(StatementRemoveYarsError) {
			@@adapter.remove(subject, predicate, object)
		}
	end
	
	def test_F_remove_triples_object_resource
		
		subject = NodeFactory.create_basic_identified_resource('http://m3pe.org/subject')
		predicate = NodeFactory.create_basic_identified_resource('http://m3pe.org/predicate')
		object = NodeFactory.create_basic_identified_resource('http://m3pe.org/object')
		
		@@adapter.add(subject, predicate, object)
		
		assert_nothing_raised(StatementRemoveYarsError) {
			@@adapter.remove(subject, predicate, object)
		}
	end
	
	def test_G_remove_triples_with_subject_as_wildcard
		subject1 = NodeFactory.create_basic_identified_resource('http://m3pe.org/subject1')
		subject2 = NodeFactory.create_basic_identified_resource('http://m3pe.org/subject2')
		predicate = NodeFactory.create_basic_identified_resource('http://m3pe.org/predicate')
		object = NodeFactory.create_basic_identified_resource('http://m3pe.org/object')
		
		@@adapter.add(subject1, predicate, object)
		@@adapter.add(subject2, predicate, object)	
		
		assert_nothing_raised(StatementRemoveYarsError) {
			@@adapter.remove(nil, predicate, object)
		}
	end

	def test_H_remove_triples_with_predicate_and_object_as_wildcard
		subject = NodeFactory.create_basic_identified_resource('http://m3pe.org/subject')
		predicate1 = NodeFactory.create_basic_identified_resource('http://m3pe.org/predicate1')
		object1 = NodeFactory.create_basic_identified_resource('http://m3pe.org/object')
		predicate2 = NodeFactory.create_basic_identified_resource('http://m3pe.org/predicate2')
		object2 = NodeFactory.create_literal('42', 'xsd:integer')
		
		@@adapter.add(subject, predicate1, object1)
		@@adapter.add(subject, predicate2, object2)
		
		assert_nothing_raised(StatementRemoveYarsError) {
			@@adapter.remove(subject, nil, nil)
		}
	end
	
	def test_I_remove_all_triples_with_wildcard
		subject1 = NodeFactory.create_basic_identified_resource('http://m3pe.org/subject1')
		subject2 = NodeFactory.create_basic_identified_resource('http://m3pe.org/subject2')
		predicate = NodeFactory.create_basic_identified_resource('http://m3pe.org/predicate')
		object = NodeFactory.create_basic_identified_resource('http://m3pe.org/object')
		
		@@adapter.add(subject1, predicate, object)
		@@adapter.add(subject2, predicate, object)	
		
		assert_nothing_raised(StatementRemoveYarsError) {
			@@adapter.remove(nil, nil, nil)
		}
	end
	
end