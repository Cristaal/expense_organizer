class Expense
  attr_reader(:date, :description, :cost, :id)

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

  define_method(:category) do
    result = DB.exec("SELECT categories.*FROM
    expenses JOIN expense_categories ON (expenses.id = expense_categories.expense_id)
             JOIN categories ON (expense_categories.category_id = categories.id)

    WHERE expenses.id = #{@self.id()};")
    result
  end
end
