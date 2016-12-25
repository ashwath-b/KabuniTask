class ShortUrlsController < ApplicationController
  before_action :require_login!, except: [:out_url]
  before_action :merge_page_number_size, only: [:index, :show]
  before_action :set_short_url, only: [:show, :update, :destroy]

  # GET /short_urls
  # GET /short_urls.json
  def index
    @short_urls = @user.short_urls.paginate(:page => params[:page][:number], :per_page => params[:page][:size])
    if @short_urls.count > 0
      render json: @short_urls, meta: pagination_details(@short_urls)
    else
      error = {}
      render json: {errors: {message: "You haven't created Short URLs yet!"}}
    end
  end

  # GET /short_urls/1
  # GET /short_urls/1.json
  def show
    if @short_url
      short_visits = @short_url.short_visits.paginate(:page => params[:page][:number], :per_page => params[:page][:size])
      if short_visits.count > 0
        result = short_visits
      else
        error = {}
        error[:errors] = "No visitors yet!!"
        result = error
      end
      render json: result
    else
      render json: {errors: {message: "No short_url with given id in your ShortUrl list."}}, status: 404
    end
  end

  # POST /short_urls
  # POST /short_urls.json
  def create
    @short_url = @user.short_urls.new(short_url_params)

    if @short_url.save
      short_url = @short_url
      short_url.shorty = "http://www.my-domain.com/#{@short_url.shorty}"
      render json: short_url, status: :created
    else
      render json: {errors: @short_url.errors}, status: :unprocessable_entity
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
      render json: {errors: {message: "No short_url with given id"}}
    end
  end

  # DELETE /short_urls/1
  # DELETE /short_urls/1.json
  def destroy
    if @short_url && @short_url.destroy
      head :no_content
    else
      render json: {errors: {message: "No short_url with given id"}}
    end
  end

  def out_url
    short_url = ShortUrl.find_by_shorty(params[:shorty])
    if short_url
      short_url.update_short_visit(request.remote_ip)
      redirect_to short_url.original_url
    else
      render json: {errors: {message: "Couldn't find the data"}}, status: 204
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
