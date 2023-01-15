class Discount < ApplicationRecord
    belongs_to :merchant

    def edit_discount(percent, quantity)
        self.update!(percent_discount: percent, quantity_threshold: quantity)
    end
end