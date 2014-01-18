#
# Copyright (C) 2012 Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.
#

require File.expand_path(File.dirname(__FILE__) + '/../api_spec_helper')

describe 'CommunicationChannels API', :type => :integration do
  describe 'index' do
    before do
      @someone = user_with_pseudonym
      @admin   = user_with_pseudonym

      Account.site_admin.add_user(@admin)

      @path = "/api/v1/users/#{@someone.id}/communication_channels"
      @path_options = { :controller => 'communication_channels',
        :action => 'index', :format => 'json', :user_id => @someone.id.to_param }
    end

    context 'an authorized user' do
      it 'should list all channels' do
        json = api_call(:get, @path, @path_options)

        cc = @someone.communication_channel
        json.should eql [{
          'id'       => cc.id,
          'address'  => cc.path,
          'type'     => cc.path_type,
          'position' => cc.position,
          'workflow_state' => 'unconfirmed',
          'user_id'  => cc.user_id }]
      end
    end

    context 'an unauthorized user' do
      it 'should return 401' do
        user_with_pseudonym
        raw_api_call(:get, @path, @path_options)
        response.code.should eql '401'
      end

      it "should not list channels for a teacher's students" do
        course_with_teacher
        @course.enroll_student(@someone)
        @user = @teacher

        raw_api_call(:get, @path, @path_options)
        response.code.should eql '401'
      end
    end
  end

  describe 'create' do
    before do
      @someone    = user_with_pseudonym
      @admin      = user_with_pseudonym
      @site_admin = user_with_pseudonym

      Account.site_admin.add_user(@site_admin)
      Account.default.add_user(@admin)

      @path = "/api/v1/users/#{@someone.id}/communication_channels"
      @path_options = { :controller => 'communication_channels',
        :action => 'create', :format => 'json',
        :user_id => @someone.id.to_param, }
      @post_params = { :communication_channel => {
        :address => 'new+api@example.com', :type => 'email' }}
    end

    it 'should be able to create new channels' do
      json = api_call(:post, @path, @path_options, @post_params.merge({
        :skip_confirmation => 1 }))

      @channel = CommunicationChannel.find(json['id'])

      json.should == {
        'id' => @channel.id,
        'address' => 'new+api@example.com',
        'type' => 'email',
        'workflow_state' => 'active',
        'user_id' => @someone.id,
        'position' => 2
      }
    end

    context 'a site admin' do
      before { @user = @site_admin }

      it 'should be able to auto-validate new channels' do
        json = api_call(:post, @path, @path_options, @post_params.merge({
          :skip_confirmation => 1 }))

        @channel = CommunicationChannel.find(json['id'])
        @channel.should be_active
      end
    end

    context 'an account admin' do
      before { @user = @admin }

      it 'should be able to create new channels for other users' do
        json = api_call(:post, @path, @path_options, @post_params)

        @channel = CommunicationChannel.find(json['id'])

        json.should == {
          'id' => @channel.id,
          'address' => 'new+api@example.com',
          'type' => 'email',
          'workflow_state' => 'unconfirmed',
          'user_id' => @someone.id,
          'position' => 2
        }
      end

      it 'should not be able to auto-validate channels' do
        json = api_call(:post, @path, @path_options, @post_params.merge({
          :skip_confirmation => 1 }))

        @channel = CommunicationChannel.find(json['id'])
        @channel.should be_unconfirmed
      end
    end

    context 'a user' do
      before { @user = @someone }

      it 'should be able to create its own channels' do
        expect {
          api_call(:post, @path, @path_options, @post_params)
        }.to change(CommunicationChannel, :count).by(1)
      end

      it 'should not be able to create channels for others' do
        raw_api_call(:post, "/api/v1/users/#{@admin.id}/communication_channels",
          @path_options.merge(:user_id => @admin.to_param), @post_params)

        response.code.should eql '401'
      end
    end
  end

  describe 'destroy' do
    before do
      @someone = user_with_pseudonym
      @admin   = user_with_pseudonym
      @channel = @someone.communication_channel

      Account.default.add_user(@admin)

      @path = "/api/v1/users/#{@someone.id}/communication_channels/#{@channel.id}"
      @path_options = { :controller => 'communication_channels',
        :action => 'destroy', :user_id => @someone.to_param, :format => 'json',
        :id => @channel.to_param }
    end

    context 'an admin' do
      it "should be able to delete others' channels" do
        json = api_call(:delete, @path, @path_options)

        json.should == {
          'position' => 1,
          'address' => 'nobody@example.com',
          'id' => @channel.id,
          'workflow_state' => 'retired',
          'user_id' => @someone.id,
          'type' => 'email'
        }
      end
    end

    context 'a user' do
      before { @user = @someone }

      it 'should be able to delete its own channels' do
        json = api_call(:delete, @path, @path_options)

        json.should == {
          'position' => 1,
          'address' => 'nobody@example.com',
          'id' => @channel.id,
          'workflow_state' => 'retired',
          'user_id' => @someone.id,
          'type' => 'email'
        }
      end

      it "should not be able to delete others' channels" do
        @channel = @admin.communication_channel
        raw_api_call(:delete, "/api/v1/users/#{@admin.id}/communication_channels/#{@channel.id}",
          @path_options.merge(:user_id => @admin.to_param, :id => @channel.to_param))

        response.code.should eql '401'
      end
    end
  end
end
