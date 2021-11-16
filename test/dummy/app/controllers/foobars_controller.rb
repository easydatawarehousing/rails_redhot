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
      do_dispatch(:add, foobar_update_action_params[:custom][0..5].capitalize)
    when :remove
      do_dispatch(:remove, foobar_update_action_params[:action_id])
    when :undo
      do_undo
    when :redo
      do_redo
    when :flatten
      do_flatten
    end

    @foobar.save! if @foobar.changed?

    redirect_back fallback_location: edit_foobar_path(@foobar), notice: notice
  end

  private
    def do_dispatch(type, item)
      value = type == :add ? item.strip
                           : item&.to_i

      if value.present? && @foobar.dispatch!(type: type, item: value)
        'Updated !'
      else
        'Invalid item'
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
