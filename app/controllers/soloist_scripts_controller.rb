class SoloistScriptsController < InheritedResources::Base
  actions :new, :create, :show
  respond_to :sh, :only => [:show]

  def create
    create!(:notice => "SoloWizard has successfully created your Soloist script. Ooooh-aaaah...")
  end

  private

  def resource
    @soloist_script = SoloistScript.find_by_uid!(params[:id])
  end
end