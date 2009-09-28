module WsForm

  def self.get_fields(model)
    field = { :integer => :text_field, :float => :text_field, :decimal => :text_field,
              :datetime => :datetime_select, :timestamp => :datetime_select, :time => :datetime_select,
              :date => :date_select,
              :binary => :text_field, :string => :text_field, :text => :text_area,
              :boolean => :check_box
    }

    hidden_cols = ['updated_at', 'created_at', 'id', 'token', 'token_expires_at', 'activ_key', 'hashed_password']
    cols = eval("#{model}.columns")

    fields = {}

    for col in cols
      if col.name =~ /_id/ || col.name =~ /able/
        fields.merge! col.name => "label"
      else
        fields.merge! col.name => field[col.type] unless hidden_cols.include?(col.name)
        fields.merge! col.name => "password_field" if col.name =~ /password/
      end

    end

    fields.to_a
  end

end