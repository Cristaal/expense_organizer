class Category

  attr_reader(:expense_type, :id)

  define_method(:initialize) do |attributes|
    @expense_type = attributes.fetch(:expense_type)
    @id = attributes.fetch(:id)
  end

  define_singleton_method(:all) do
    returned_categories = DB.exec("SELECT * FROM categories")
    categories = []
    returned_categories.each() do |category|
      expense_type = category.fetch("expense_type")
      id = category.fetch("id").to_i()
      categories.push(Category.new({:expense_type => expense_type, :id => id}))
    end
    categories
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO categories (expense_type) VALUES ('#{@expense_type}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end

  define_singleton_method(:find) do |id|
    found_category = nil
    Category.all().each() do |category|
      if category.id().==(id)
        found_category = category
      end
    end
    found_category
  end

  define_method(:==) do |another_category|
    self.expense_type().==(another_category.expense_type()).&(self.id().==(another_category.id()))
  end
end
