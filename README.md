## JubiPago – Análisis y Diseño de Software

Este repositorio contiene el desarrollo del proyecto JubiPago, realizado en el marco del Taller de Proyecto de la carrera de Tecnicatura en las ciencias de la computación. El objetivo es diseñar y desarrollar una aplicación de pagos destinada a jubilados, enfocándose en la usabilidad, seguridad y eficiencia.

📄 Documentación

    Figma: Diseño de la interfaz de usuario.
    https://www.figma.com/design/T6FTRXlNtsrcSGkuEA8t5K/Untitled?node-id=0-1

    Miro: Diagramas de flujo y arquitectura del sistema.
    https://miro.com/welcomeonboard/dDZKQjl6NldwdnpabldQWmdxL0E5YVBzaTV6WGRTVWhFbWNSUXI0Q1V0SmJrUWJyc1dCSUNIN3dtS21qb2J4OVpXcEJ0VmVPbzRVNXlSRmMyK0haU2dnc2tNb0pYQVo2dldSRXAzRnh1VkhCMmRuTDgzam9JK1hTRHIyUk9RS3NyVmtkMG5hNDA3dVlncnBvRVB2ZXBnPT0hdjE

    Documentos clave:

        Product Backlog - JubiPago.pdf

        SRS.pdf (Especificación de Requisitos del Software)

        Diagramas UML:

            Contexto del sistema

            Clases

            Objetos

⚙️ Instalación

    Clonar el repositorio:

    git clone https://github.com/ValentinPastre/AnalisisYDise-o_Taller_Proyecto.git
    cd AnalisisYDise-o_Taller_Proyecto

    Construir la imagen Docker:

        docker-compose build

    Ejecutar el contenedor:

        docker-compose up
    
    Crear la base de datos:

        docker-compose exec app bundle exec rake db:create

🚀 Uso

Una vez iniciado el contenedor, la aplicación estará disponible en http://localhost:3000. Desde allí, se puede interactuar con la interfaz de usuario diseñada para facilitar los pagos de los jubilados.

🛠️ Tecnologías utilizadas

    Ruby: Lenguaje de programación principal.

    Docker: Contenerización de la aplicación para facilitar su despliegue.

    Figma: Diseño de interfaces de usuario.

    Miro: Diagramación y planificación del proyecto.

👥 Autores

    Valentín Pastre

    Francisco Gribaudo
    
    Camilo Girardi
    
    Francisco Andeani
    
    Fabricio Parejo