class SecurityQuestion
    attr_accessor :question, :answer

    def set_question()
            puts "Ingresa una pregunta de seguridad"
            @question = gets
    end

    def set_answer()
            puts "Ingresa la respuesta a la pregunta de seguridad"
            @answer = gets
    end
end