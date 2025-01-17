require 'rails_helper'

RSpec.describe 'Bulk discount index' do
    before :each do
        @merchant1 = Merchant.create!(name: 'Hair Care')
    
        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
        @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
        @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
        @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
        @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Kuhn')
    
        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
        @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
        @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
        @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
        @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
        @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
        @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)
    
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
        @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
        @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
        @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)
    
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
        @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
        @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
        @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
        @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
        @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
        @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    
        @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
        @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
        @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
        @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
        @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
        @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
        @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)

        @discount1 = @merchant1.discounts.create!(quantity_threshold: 50, percent_discount: 20)
        @discount2 = @merchant1.discounts.create!(quantity_threshold: 20, percent_discount: 5)
        @discount3 = @merchant1.discounts.create!(quantity_threshold: 100, percent_discount: 50)
    end

    it 'has all bulk discounts for a particular merchant' do
        visit merchant_discounts_path(@merchant1)

        expect(page).to have_link('20.0% Off 50 or more')
        expect(page).to have_link('50.0% Off 100 or more')

        expect(page).to have_content(@merchant1.discounts.first.quantity_threshold)
        expect(page).to have_content(@merchant1.discounts.first.percent_discount)

        expect(page).to have_content(@merchant1.discounts.last.quantity_threshold)
        expect(page).to have_content(@merchant1.discounts.last.percent_discount)
    end

    it 'has a link to create a new discount' do
        visit merchant_discounts_path(@merchant1)

        expect(page).to have_link('New Discount')
        click_link('New Discount')
        expect(current_path).to eq(new_merchant_discount_path(@merchant1))

        expect(page).to have_field('Percent Discount')
        expect(page).to have_field('Quantity Threshold')

        fill_in('Percent Discount', with: 33.33)
        fill_in('Quantity Threshold', with: 70)
        click_button('Submit')

        expect(current_path).to eq(merchant_discounts_path(@merchant1))

        expect(page).to have_content("33.33% Off 70 or more")
    end

    it 'has a link next to each discount to delete it' do
        visit merchant_discounts_path(@merchant1)

        within('div#0') do
            expect(page).to have_content('20.0% Off 50 or more')
            expect(page).to have_link('Delete Discount')
            click_link('Delete Discount')
        end

        expect(current_path).to eq(merchant_discounts_path(@merchant1))
        expect(page).to_not have_content('20.0% Off 50 or more')

        within('div#1') do
            expect(page).to have_content('50.0% Off 100 or more')
            expect(page).to have_link('Delete Discount')
            click_link('Delete Discount')
        end

        expect(current_path).to eq(merchant_discounts_path(@merchant1))
        expect(page).to_not have_content('50.0% Off 100 or more')
    end

    it 'has a section with the name and date of the next three upcoming US holidays' do
        visit merchant_discounts_path(@merchant1)

        within('section#upcoming_holidays') do
            expect(page).to have_content('Presidents Day')
            expect(page).to have_content('2023-02-20')

            expect(page).to have_content('Memorial Day')
            expect(page).to have_content('2023-05-29')
        end
    end
end