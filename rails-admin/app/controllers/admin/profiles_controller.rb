# frozen_string_literal: true

module Admin
  class ProfilesController < Admin::ApplicationController
    # GET /admin/profiles/:id/download_pdf
    def download_pdf
      pdf_service_url = Rails.application.config.x.pdf_service_url

      response = Faraday.get("#{pdf_service_url}/api/resume.pdf")

      if response.success?
        send_data(
          response.body,
          filename: 'resume.pdf',
          type: 'application/pdf',
          disposition: 'attachment'
        )
      else
        redirect_to admin_profile_path(params[:id]),
                    alert: 'PDF service unavailable'
      end
    rescue Faraday::Error => e
      redirect_to admin_profile_path(params[:id]),
                  alert: "PDF generation failed: #{e.message}"
    end
  end
end
