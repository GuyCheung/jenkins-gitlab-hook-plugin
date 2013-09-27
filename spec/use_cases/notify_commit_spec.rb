require 'spec_helper'

module GitlabWebHook
  describe NotifyCommit do
    let(:project) { double(Project, :is_ignoring_notify_commit? => false, :is_buildable? => true) }
    let(:logger) { double }
    let(:subject) { NotifyCommit.new(project, logger) }

    context "when project configured to ignore notify commit" do
      it "skips the build" do
        project.stub(:is_ignoring_notify_commit?).and_return(true)

        expect(project).not_to receive(:schedulePolling)
        expect(subject.call).to match("configured to ignore notify commit")
      end
    end

    context "when project not buildable" do
      it "skips the build" do
        project.stub(:is_buildable?).and_return(false)

        expect(project).not_to receive(:schedulePolling)
        expect(subject.call).to match("not buildable")
      end
    end

    context "when notify commit triggered" do
      context "successfully" do
        it "schedules polling" do
          expect(project).to receive(:schedulePolling).and_return(true)
          expect(subject.call).to match("scheduled for polling")
        end
      end

      context "unsuccessfully" do
        it "logs error and returns appropriate message" do
          expect(project).to receive(:schedulePolling).and_raise(java.lang.Exception.new)
          expect(logger).to receive(:log)
          expect(subject.call).to match("could not be scheduled for polling")
        end
      end
    end
  end
end
