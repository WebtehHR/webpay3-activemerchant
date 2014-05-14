json.array!(@orders) do |order|
  json.extract! order, :id, :order_number, :currency, :amount, :status
  json.url order_url(order, format: :json)
end
