class Expense
  attr_reader(:date, :description, :cost, :category_id, :id)

  define_method(:initialize) do |attributes|
    @date = attributes.fetch(:date)
    @description = attributes.fetch(:description)
    @cost = attributes.fetch(:cost)
    @id = attributes.fetch(:id)
  end

  define_singleton_method(:all) do
    returned_expenses = DB.exec("SELECT * FROM expenses;")
    expenses = []
    returned_expenses.each() do |expense|
      date = expense.fetch("date")
      description = expense.fetch("description")
      cost = expense.fetch("cost")
      id = expense.fetch("id").to_i()
      expenses.push(Expense.new({:date => date, :description => description, :cost => cost, :id => id }))
    end
    expenses
  end

  define_method(:save) do
    result = DB.exec( "INSERT INTO expenses (date, description, cost) VALUES ('#{@date}', '#{@description}', '#{@cost}') RETURNING id;" )
    @id = result.first().fetch("id").to_i()
  end

   define_method(:==) do |another_expense|
     self.description().==(another_expense.description()).&(self.id().==(another_expense.id()))
  end

  define_singleton_method(:find) do |id|
    found_expense = nil
    Expense.all().each() do |expense|
      if expense.id().==(id)
        found_expense = expense
      end
    end
    found_expense
  end

  define_method(:add_category) do |category|
    DB.exec("INSERT INTO expense_categories (expense_id, category_id) VALUES (#{self.id()}, #{category.id()})")
  end

  define_method(:find_categories) do
    result = DB.exec("SELECT categories.* FROM
    expenses JOIN expense_categories ON (expenses.id = expense_categories.expense_id)
             JOIN categories ON (expense_categories.category_id = categories.id)
    WHERE expenses.id = #{self.id()};")
    categories = []
    result.each() do |category|
      expense_type = category.fetch("expense_type")
      id = category.fetch("id").to_i()
      returned_categories = Category.new({:expense_type => expense_type, :id => id})
      categories.push(returned_categories)
    end
    categories
  end
end
