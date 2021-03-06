# encoding: UTF-8

class GeojsonController < ApplicationController
  caches_action :geojson, :expires_in => 300.seconds

  def geojson
    @addresses = Address.where(country: params[:country])

    case params[:type]
    when 's'
      @addresses = @addresses.tagged_with("speakers")
    when 'd'
      @addresses = @addresses.tagged_with("dealers")
    when 'l'
      @addresses = @addresses.tagged_with("locations")
    end

    case params[:product]
    when 'c'
      @addresses = @addresses.tagged_with("PC")
    when 'k'
      @addresses = @addresses.tagged_with("PK")
    when 'b'
      @addresses = @addresses.tagged_with("PB")
    end

    @geopoint = params[:geocode].split(",").collect{|c| c.to_f}
    @addresses.sort_by! do |a|
      a.distance(@geopoint)
    end
  end

end
