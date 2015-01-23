require('spec_helper')
require('pg')
require('expense')


describe(Category) do

  describe(".all") do
    it("is empty at first") do
      expect(Category.all()).to(eq([]))
    end
  end

  describe("#save") do
    it("saves the category to the category database") do
      test_category = Category.new({:expense_type => "Restaurants", :id => nil})
      test_category.save()
      expect(Category.all()).to(eq([test_category]))
    end
  end

  describe("#==") do
    it("is the same category if it has the same type name") do
      test_category1 = Category.new({:expense_type => "Restaurants", :id => nil})
      test_category2 = Category.new({:expense_type => "Restaurants", :id => nil})
      expect(test_category1).to(eq(test_category2))
    end
  end

  describe(".find") do
    it("returns a category by its ID number") do
      test_category = Category.new({:expense_type => "Restaurants", :id => nil})
      test_category.save()
      test_category2 = Category.new({:expense_type => "Hotels", :id => nil})
      test_category2.save()
      expect(Category.find(test_category2.id())).to(eq(test_category2))
    end
  end

  # describe("find_table_id") do
  #   it("returns the id for a partiular table entry") do
  #    test_category = Category.new({:expense_type => "Restaurants", :id => nil})
  #    test_category.save()
  #    test_expense = Expense.new({:})
  #   end
  # end
end
