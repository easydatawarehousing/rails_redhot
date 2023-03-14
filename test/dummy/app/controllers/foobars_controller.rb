class FoobarsController < ApplicationController
  before_action :set_foobar, only: %i[ show edit update update_action destroy ]

  # GET /foobars
  def index
    @foobars = Foobar.all
  end

  # GET /foobars/1
  def show
  end

  # GET /foobars/new
  def new
    @foobar = Foobar.new
  end

  # GET /foobars/1/edit
  def edit
  end

  # POST /foobars
  def create
    @foobar = Foobar.new(foobar_params)

    if @foobar.save
      redirect_to @foobar, notice: "Foobar was successfully created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /foobars/1
  def update
    if @foobar.update(foobar_params)
      redirect_to @foobar, notice: "Foobar was successfully updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /foobars/1
  def destroy
    @foobar.destroy
    redirect_to foobars_url, notice: "Foobar was successfully destroyed"
  end

  # PUT /foobars/1/update_action
  def update_action
    notice = case foobar_update_action_params[:action].to_sym
    when :add_foo
      do_dispatch(:add, 'Foo')
    when :add_bar
      do_dispatch(:add, 'Bar')
    when :add_custom
      do_dispatch(:add, foobar_update_action_params[:custom].strip.capitalize)
    when :remove
      do_dispatch(:remove, foobar_update_action_params[:action_id]&.to_i)
    when :undo
      do_undo
    when :redo
      do_redo
    when :flatten
      do_flatten
    end

    @foobar.reload if !@foobar.reduce_valid?
    @foobar.save!  if @foobar.changed?

    pp_acts_as_redux

    flash.now.notice = notice if notice.present?
    render :edit
  end

  private

    def do_dispatch(type, value)
      return if value.blank?

      if @foobar.dispatch!(type: type, item: value)
        'Updated !'
      else
        @foobar.reduce_errors.full_messages.join('. ')
      end
    end

    def do_undo
      @foobar.undo! ? 'Its undone !' : 'Nothing to undo'
    end

    def do_redo
      @foobar.redo! ? 'Its redone !' : 'Nothing to redo'
    end

    def do_flatten
      @foobar.flatten! ? 'Saved !' : 'Nothing to save'
    end

    def pp_acts_as_redux
      puts '='*80
      puts "Initial state: #{@foobar.my_redux['initial_state']&.dig('total') || 0} items"
      pp @foobar.my_redux['initial_state']&.dig('items')

      puts "\nCurrent state: #{@foobar.my_redux['state']&.dig('total') || 0} items"
      pp @foobar.my_redux['state']&.dig('items')

      puts "\nList of actions:"
      @foobar.my_redux['actions'].each_with_index do |action, i|
        puts "#{i == @foobar.my_redux['head'] ? 'HEAD =>' : ' '*7} #{action['type'].ljust(6)} : '#{action['item']}'"
      end

      puts "\nLast used sequence-id: #{@foobar.my_redux['seq_id']}"
      puts '='*80
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_foobar
      @foobar = Foobar.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def foobar_params
      params.fetch(:foobar, {})
    end

    # Only allow a list of trusted parameters through.
    def foobar_update_action_params
      params.require(:foobar).permit(:action, :action_id, :custom)
    end
end
