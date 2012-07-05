#
# Copyright 2011 National Institute of Informatics.
#
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
class LogsController < ApplicationController

  def index
    @logs = nil
    if params.has_key? "proposal_id"
      proposal = Proposal.find_by_id_and_user_id(params[:proposal_id], current_user.id)
      @logs = proposal.logs if proposal
    else
      @logs = Log.joins(:proposal).where('proposals.user_id' => current_user.id)
    end

    respond_to do |format|
      if @logs
        format.html
        format.json { render :json => JSON.pretty_generate(@logs.as_json) }
      else
        format.html { redirect_to(proposals_url) }
        format.json { render :json => {:errors => "You don't have permission or the proposal does not exist."}.as_json }
      end
    end
  end
end
