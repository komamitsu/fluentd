#
# Fluentd
#
# Copyright (C) 2011-2012 FURUHASHI Sadayuki
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#
module Fluentd
  module Builtin

    class StdoutOutput < Agent
      # TODO create base class for Output plugins
      include Collector

      Plugin.register_output(:stdout, self)

      def initialize
        @mutex = Mutex.new
      end

      def configure(conf)
      end

      def open(tag, &block)
        @mutex.synchronize do
          @tag = tag
          yield self
        end
      end

      def append(time, record)
        puts "#{time} #{@tag} #{record.to_json}"
      end

      def write(chunk)
        chunk.each(&method(:append))
      end
    end

  end
end