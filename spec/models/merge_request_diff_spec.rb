# == Schema Information
#
# Table name: merge_request_diffs
#
#  id               :integer          not null, primary key
#  state            :string(255)      default("collected"), not null
#  st_commits       :text
#  st_diffs         :text
#  merge_request_id :integer          not null
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

describe MergeRequestDiff do

  describe 'Mass assignment' do
    it { should_not allow_mass_assignment_of(:merge_request_id) }
  end

  describe 'state_machine' do
    it { should respond_to(:collected?) }
    it { should respond_to(:timeout?) }
    it { should respond_to(:overflow_commits_safe_size?) }
    it { should respond_to(:overflow_diff_files_limit?) }
    it { should respond_to(:overflow_diff_lines_limit?) }
  end

  describe 'with diffs' do
    subject {
      mr = create(:simple_merge_request)
      mr.merge_request_diff
    }

    describe '#stats' do
      it 'computes additions' do
        expect(subject.stats.additions).to eq 2
      end

      it 'computes deletions' do
        expect(subject.stats.deletions).to eq 2
      end

      it 'computes total' do
        expect(subject.stats.total).to eq 4
      end
    end

    describe '#has_zero_stats?' do
      it 'returns false' do
        expect(subject.has_zero_stats?).to be_false
      end
    end
  end

  describe 'without diffs' do
    subject {
      mr = create(:merge_request_without_diffs)
      mr.merge_request_diff
    }

    describe '#stats' do
      it 'computes additions' do
        expect(subject.stats.additions).to be_zero
      end

      it 'computes deletions' do
        expect(subject.stats.deletions).to be_zero
      end

      it 'computes total' do
        expect(subject.stats.total).to be_zero
      end
    end

    describe '#has_zero_stats?' do
      it 'returns false' do
        expect(subject.has_zero_stats?).to be_true
      end
    end
  end

end
