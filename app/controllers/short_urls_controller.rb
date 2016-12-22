class ShortUrlsController < ApplicationController
  before_action :require_login!, except: [:out_url]
  before_action :set_short_url, only: [:show, :update, :destroy]

  # GET /short_urls
  # GET /short_urls.json
  def index
    @short_urls = @user.short_urls.paginate(:page => params[:page] || 1, :per_page => params[:per_page] || 5)
    result = []
    result << @short_urls
    paging = {}
    paging[:next] = generate_url(@short_urls.next_page, @short_urls.per_page) if @short_urls.current_page < @short_urls.total_pages
    paging[:previous] = generate_url(@short_urls.previous_page, @short_urls.per_page) if @short_urls.current_page > 1
    result << paging
    render json: result
  end

  # GET /short_urls/1
  # GET /short_urls/1.json
  def show
    if @short_url
      render json: @short_url.short_visits.paginate(:page => params[:page] || 1, :per_page => params[:per_page] || 5)
    else
      render json: {message: "No short_url with given id"}, status: 204
    end
  end

  # POST /short_urls
  # POST /short_urls.json
  def create
    @short_url = @user.short_urls.new(short_url_params)

    if @short_url.save
      short_url = @short_url
      short_url.shorty = "http://www.my-domain.com/#{@short_url.shorty}"
      render json: short_url, status: :created, location: @short_url
    else
      render json: @short_url.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /short_urls/1
  # PATCH/PUT /short_urls/1.json
  def update
    if @short_url
      if @short_url.update(short_url_params)
        render json: {message: "Successfully updated"}, status: 204
      else
        render json: @short_url.errors, status: :unprocessable_entity
      end
    else
      render json: {message: "No short_url with given id"}
    end
  end

  # DELETE /short_urls/1
  # DELETE /short_urls/1.json
  def destroy
    if @short_url.destroy
      head :no_content
    else
      render json: {message: "No short_url with given id"}, status: 204
    end
  end

  def out_url
    short_url = ShortUrl.find_by_shorty(params[:shorty])
    if short_url
      short_url.update_short_visit(request.remote_ip)
      redirect_to short_url.original_url
    else
      render json: {errors: "Couldn't find the data"}, status: 204
    end
  end

  private

    def set_short_url
      @short_url = @user.short_urls.find_by_id(params[:id])
    end

    def short_url_params
      params.permit(:original_url, :id)
    end
end
