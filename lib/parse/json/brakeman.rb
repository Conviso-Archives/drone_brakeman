# encoding: utf-8

require 'json'

module Parse
  module Json
    class Brakeman
      def parse_file(json_file)
        struct = nil
        begin
	      struct = __extract_json(json_file)
	    rescue Exception => e
          raise Exception.new 'JSON with invalid format'
        end
        return struct
      end
     
     
      private
      def __extract_json(json_file)
        fd = File.open(json_file)
        doc = JSON.load(fd)
        
        output = {}
        output[:issues] = []
        app_path = doc['scan_info']['app_path']
        duration = doc['scan_info']['duration']
        toolversion = doc['scan_info']['brakeman_version']
        toolname = "Brakeman Scanner #{toolversion}"
        start = doc['scan_info']['start_time']

        output[:issues] = doc['warnings'].map do |warning|
          {
            :name => warning['warning_type'],
            :_hash => warning['fingerprint'],
            :description => warning['message'],
            :affected_component => "Aplicação: #{app_path}\n\n"\
                                   "Arquivo: #{warning['file']}\n\n"\
                                   "Linha: #{warning['line']}\n\n"\
                                   "Código: #{warning['code']}\n\n"\
                                   "Entrada do usuário: #{warning['user_input']}\n\n"\
                                   "Nível de confiança do aviso: #{warning['confidence']}\n\n",
            :reference => warning['link']
          }
        end
        output[:duration]=duration
        output[:start_datetime]=start
        output[:toolname]=toolname

        # eliminando repetidos
        output[:issues].uniq!
        
        return output
      end
      
    end
  end
end
