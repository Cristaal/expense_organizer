require('spec_helper')

describe(Expense) do

    describe(".all") do
      it("is empty at first") do
        expect(Expense.all()).to(eq([]))
      end
    end

    describe("#save") do
      it("pushes the expense object into the expenses array") do
        test_expense = Expense.new({ :date => "1/22/2015", :description => "description", :cost => 50, :id => nil })
        test_expense.save()
        expect(Expense.all()).to(eq([test_expense]))
      end
    end

    describe('#==') do
      it('is the same expense if it has the same name') do
        expense1 = Expense.new({:date => "1/22/2015", :description => "description", :cost => 50, :id => nil })
        expense2 = Expense.new({:date => "1/22/2015", :description => "description", :cost => 50, :id => nil })
        expect(expense1).to(eq(expense2))
      end
    end

  describe('.find') do
    it("returns an expense by its ID number") do
      expense1 = Expense.new({:date => "1/22/2015", :description => "description", :cost => 50, :id => nil })
      expense1.save()
      expense2 = Expense.new({:date => "1/15/2015", :description => "dinner", :cost => 60, :id => nil })
      expense2.save()
      expect(Expense.find(expense1.id())).to(eq(expense1))
    end
  end

  describe('#add_category') do
    it("joins category to an expense") do
      expense1 = Expense.new({:date => "1/22/2015", :description => "Lunch", :cost => 50, :id => nil })
      expense1.save()
      test_category1 = Category.new({:expense_type => "Restaurants", :id => nil})
      test_category1.save()
      expense1.add_category(test_category1)
      expect(expense1.find_categories()).to(eq([test_category1]))
    end
  end
end
