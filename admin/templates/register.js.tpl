var poliradio_registration = new Vue({

    el : '#poliradio_registration',
    data : {

        //object with lable and sentence that must be show in the selected language
        italian_name : {
            //scritte della pagina
            title : 'Modulo Iscrizione POLI.RADIO',
            registration_success_msg : 'Registrazione effettuata con successo. Controlla la casella di posta in arrivo per verificare la tua email!',
            //campi del form
            name : 'Nome',
            surname : 'Cognome',
            nickname : 'Soprannome',
            gender : 'Sesso',
            gender_option : [
                {gender_id : 1,
                    gender_value: 'Femmina'},
                {gender_id : 2,
                    gender_value: 'Maschio'},
                {gender_id : 3,
                    gender_value: 'Altro'}
            ],
            birth_date : 'Data di Nascita',
            district_birth : 'Provincia di Nascita',
            place_birth : 'Luogo di Nascita',
            country_birth : 'Stato di Nascita',
            permanent_address: 'Residenza',
            current_address:'Domicilio',
            copy_permanent_address:'Copia Residenza',
            address : 'Indirizzo',
            street : 'Via/Piazza',
            house_number: 'Civico',
            cap: 'CAP',
            city: 'Comune',
            district: 'Provincia',
            district_abroad : 'Estero',
            country : 'Stato',
            cf : 'Codice Fiscale',
            prefix : 'Prefisso',
            phone : 'Telefono',
            email : 'Email',
            telegram : 'Telegram',
            politecnico_student : 'Sei uno studente del Politecnico?',
            politecnico_student_option : [
                {politecnico_student_id : 1,
                    politecnico_student_value: 'Sì'},
                {politecnico_student_id : 2,
                    politecnico_student_value: 'No'},
            ],
            personal_code : 'Codice Persona',
            password : 'Password',
            password2 : 'Ripeti Password',

            //errori

            wrong_feedback : {

                name : '',
                surname : '',
                nickname : '',
                gender : '',
                birth_date : 'Devi avere almeno 16 anni per iscriverti a POLI.RADIO',
                place_birth : '',
                district_birth : '',
                country_birth : '',
                address : '',
                street : '',
                house_number : 'Sono consentiti civici come 14,14A,14/A,14/2,14-2, indicare SNC se il civico non è presente, indicare ALTRO se il formato non è valido',
                cap : '',
                city : '',
                district : '',
                country : '',
                cf : '',
                prefix : '',
                phone : '',
                email : '',
                telegram: 'L\'username telegram può contenere solo numeri,lettere o _ (underscore)',
                politecnico_student : '',
                personal_code : '',
                password : 'La password deve avere almeno 6 caratteri',
                password2 : '',

            },

            right_feedback : {

                name : '',
                surname : '',
                nickname : '',
                gender : '',
                birth_date : '',
                place_birth : '',
                country_birth : '',
                address : '',
                street : '',
                house_number : '',
                cap : '',
                city : '',
                district : '',
                country : '',
                cf : '',
                prefix : '+',
                phone : '',
                email : '',
                telegram: '',
                politecnico_student : '',
                personal_code : '',
                password : '',
                password2 : '',

            },

        },

        english_name: {

            title : 'POLI.RADIO Registration Form',
            registration_success_msg : 'Registration successful. Check your inbox to verify your email!',
            name : 'Name',
            surname : 'Last Name',
            nickname : 'Nickname',
            gender : 'Gender',
            gender_option: [
                {gender_id : 1,
                    gender_value: 'Female'},
                {gender_id : 2,
                    gender_value: 'Male'},
                {gender_id : 3,
                    gender_value: 'Other'}
            ] ,
            birth_date : 'Date of Birth',
            district_birth : 'District of Birth',
            place_birth : 'Place of Birth',
            country_birth : 'Country of Birth',
            permanent_address: 'Permanent Address',
            current_address:'Current Address',
            copy_permanent_address:'Copy Permanent Address',
            address : 'Address',
            street : 'Via/Piazza',
            house_number: 'Number',
            cap: 'Postal Code',
            city: 'City',
            district: 'District',
            district_abroad : 'Abroad',
            country : 'Country',
            cf : 'Fiscal Code',
            prefix : 'Prefix',
            phone : 'Phone Number',
            email : 'Email',
            telegram : 'Telegram',
            politecnico_student : 'Are you a student of Politecnico?',
            politecnico_student_option : [
                {politecnico_student_id : 1,
                    politecnico_student_value: 'Yes'},
                {politecnico_student_id : 2,
                    politecnico_student_value: 'No'},
            ],
            personal_code : 'Personal Code',
            password : 'Password',
            password2 : 'Confirm Password',

            //errors feedback

            wrong_feedback : {

                name : '',
                surname : '',
                nickname : '',
                gender : '',
                birth_date : 'You must have at least 16 years old to subscribe at POLI.RADIO',
                place_birth : '',
                district_birth : '',
                country_birth : '',
                address : '',
                street : '',
                house_number : 'Are valid house numbers like 14,14A,14/A,14/2,14-2, type SNC if the house hasn\'t a number, type ALTRO if the format is invalid',
                cap : '',
                city : '',
                district : '',
                country : '',
                cf : '',
                prefix : '',
                phone : '',
                email : '',
                telegram: 'The telegram username is made only by numbers, letters and underscore(_)',
                politecnico_student : '',
                personal_code : '',
                password : 'The password lenght must be at least six characters',
                password2 : '',

            },

            right_feedback : {

                name : '',
                surname : '',
                nickname : '',
                gender : '',
                birth_date : '',
                place_birth : '',
                country_birth : '',
                address : '',
                street : '',
                house_number : '',
                cap : '',
                city : '',
                district : '',
                country : '',
                cf : '',
                prefix : '+',
                phone : '',
                email : '',
                telegram: '',
                politecnico_student : '',
                personal_code : '',
                password : '',
                password2 : '',

            },


        },

        show_name : {

            title : 'Modulo Iscrizione POLI.RADIO',
            registration_success_msg : 'Registrazione effettuata con successo. Controlla la casella di posta in arrivo per verificare la tua email!',
            name : 'Nome',
            surname : 'Cognome',
            nickname : 'Soprannome',
            gender : 'Sesso',
            gender_option:[
                {gender_id : 1,
                    gender_value: 'Femmina'},
                {gender_id : 2,
                    gender_value: 'Maschio'},
                {gender_id : 3,
                    gender_value: 'Altro'}
            ],
            birth_date : 'Data di Nascita',
            place_birth : 'Luogo di Nascita',
            district_birth : 'Provincia di Nascita',
            country_birth : 'Stato di Nascita',
            permanent_address: 'Residenza',
            current_address:'Domicilio',
            copy_permanent_address:'Copia Residenza',
            address : 'Indirizzo',
            street: 'Via/Piazza',
            house_number: 'Civico',
            cap: 'CAP',
            city: 'Comune',
            district: 'Provincia',
            district_abroad : 'Estero',
            country : 'Stato',
            cf : 'Codice Fiscale',
            prefix : 'Prefisso',
            phone : 'Telefono',
            email : 'Email',
            telegram : 'Telegram',
            politecnico_student : 'Sei uno studente del Politecnico?',
            politecnico_student_option : [
                {politecnico_student_id : 1,
                    politecnico_student_value: 'Sì'},
                {politecnico_student_id : 2,
                    politecnico_student_value: 'No'},
            ],
            personal_code : 'Codice Persona',
            password : 'Password',
            password2 : 'Ripeti Password',

            //errors feedback

            wrong_feedback : {

                name : '',
                surname : '',
                nickname : '',
                gender : '',
                birth_date : 'Devi avere almeno 16 anni per iscriverti a POLI.RADIO',
                place_birth : '',
                district_birth : '',
                country_birth : '',
                address : '',
                street : '',
                house_number : 'Sono consentiti civici come 14,14A,14/A,14/2,14-2, indicare SNC se il civico non è presente, indicare ALTRO se il formato non è valido',
                cap : '',
                city : '',
                district : '',
                country : '',
                cf : '',
                prefix : '',
                phone : '',
                email : '',
                telegram: 'L\'username telegram può contenere solo numeri,lettere o _ (underscore)',
                politecnico_student : '',
                personal_code : '',
                password : 'La password deve avere almeno 6 caratteri',
                password2 : '',

            },

            right_feedback : {

                name : '',
                surname : '',
                nickname : '',
                gender : '',
                birth_date : '',
                place_birth : '',
                country_birth : '',
                address : '',
                street : '',
                house_number : '',
                cap : '',
                city : '',
                district : '',
                country : '',
                cf : '',
                prefix : '+',
                phone : '',
                email : '',
                telegram: '',
                politecnico_student : '',
                personal_code : '',
                password : '',
                password2 : '',

            },

        },

        //variables of the page

        language : 'IT',

        //variables of the form
        form_value : {

            name : '',
            surname : '',
            nickname : '',
            gender : '',
            birth_date : '',
            place_birth : '',
            district_birth : '',
            country_birth : '',
            permanent_address : {
                address : '',
                //street : '',
                house_number : '',
                cap : '',
                city : '',
                district : '',
                country : 'Italia'
            },

            current_address : {
                address : '',
                //street : '',
                house_number : '',
                cap : '',
                city : '',
                district : '',
                country : 'Italia'
            },

            cf : '',
            prefix : '39',
            phone : '',
            email : '',
            telegram: '@',
            politecnico_student : '',
            personal_code : '',
            password : '',
            password2 : '',

        },

        form_value_old : {

            name : 'Pinuccio',
            surname : 'Parenzo',
            nickname : '',
            gender : '1',
            birth_date : '2001-10-10',
            place_birth : 'Milano',
            district_birth : 'Milano',
            country_birth : 'Italia',
            permanent_address : {
                address : 'Via Francesco Spighi',
                //street : '',
                house_number : '4',
                cap : '20398',
                city : 'Milano',
                district : 'Milano',
                country : 'Italia'
            },

            current_address : {
                address : 'Via Francesco Spighi',
                //street : '',
                house_number : '4',
                cap : '20398',
                city : 'Milano',
                district : 'Milano',
                country : 'Italia'
            },

            cf : 'mrnmtt01l28f205u',
            prefix : '39',
            phone : '3245678902',
            email : 'fspighi@gmail.com',
            telegram: '@fspig',
            politecnico_student : '1',
            personal_code : '10989398',
            password : 'asdfgh',
            password2 : 'asdfgh',

        },

        //list of the errors, and tip for correction

        errors : {

            name : {
                valid : '',
            },

            surname : {
                valid : '',
            },

            nickname : {
                valid : '',
            },

            gender : {
                valid : '',
            },

            birth_date : {
                valid : '',
            },

            place_birth : {
                valid : '',
            },

            district_birth : {
                valid : '',
            },

            country_birth : {
                valid : '',
            },

            permanent_address : {

                address : {
                    valid : '',
                },

                street : {
                    valid : '',
                },

                house_number : {
                    valid : '',
                },

                cap : {
                    valid : '',
                },

                city : {
                    valid : '',
                },

                district : {
                    valid : '',
                },

                country : {
                    valid : '',
                }
            },

            current_address : {
                address : {
                    valid : '',
                },

                street : {
                    valid : '',
                },

                house_number : {
                    valid : '',
                },

                cap : {
                    valid : '',
                },

                city : {
                    valid : '',
                },

                district : {
                    valid : '',
                },

                country : {
                    valid : '',
                }

            },

            cf : {
                valid : '',
            },

            prefix : {
                valid : '',
            },

            phone : {
                valid : '',
            },

            email : {
                valid : '',
            },

            telegram : {
                valid : '',
            },

            politecnico_student : {
                valid : '',
            },

            personal_code : {
                valid : '',
            },

            password : {
                valid : '',
            },

            password2 : {
                valid : '',
            },

        },

        //variabile di stato, >0 se il form è compilato male, 0 altrimenti;
        form_not_ok : 0,

        //Segna se il form è stato inviato almeno una volta
        first_submit : false,

        //variabile che indica se l'iscrizione è andata a buon fine
        success : false,

    },

    methods : {

        change_language(lang){
            this.language = lang;

            if(this.language == 'IT'){
                this.show_name = this.italian_name
            }else{
                this.show_name = this.english_name
            }
        },

        copy_permanent_address(){

            Object.assign(this.form_value.current_address, this.form_value.permanent_address);

        },

        auto_compile(data,err){
            //sostituisce i valori di form_value con quelli dell'array $_POST
            //in caso di fail del beckend

            if(data.length === 0 && err.lenght === 0){
                return
            }else{
                //codice per sostituire i dati presenti/non presenti nel form con quelli ricevuti dal server!

                //codice per segnalare gli errori lato server
                //per il momento mostro un pop up con scritto cosa ha dato errore
                alert(err.msg[0]);
            }

            this.check_form();

        },

        check_form(){

            this.errors.name.valid = onlyLettersAndSpaces(this.form_value.name) ? true : false;

            this.errors.surname.valid = onlyLettersAndSpaces(this.form_value.surname) ? true : false;

            this.errors.nickname.valid = (onlyLettersAndSpaces(this.form_value.nickname) || this.form_value.nickname == '') ? true : false;

            this.errors.gender.valid = notEmpty(this.form_value.gender) ? true : false;

            this.errors.birth_date.valid = birthDateCheck(this.form_value.birth_date) ? true : false;

            this.errors.place_birth.valid = onlyLettersAndSpaces(this.form_value.place_birth) ? true : false;

            this.errors.district_birth.valid = notEmpty(this.form_value.district_birth) ? true : false;

            this.errors.country_birth.valid = (notEmpty(this.form_value.country_birth) && this.form_value.country_birth != 0)? true : false;

            if(this.form_value.country_birth != 'Italia' && this.form_value.country_birth != ''){
                this.form_value.district_birth = 'ESTERO';
            }

            for (type_address of ['permanent_address','current_address']){

                this.errors[type_address].street.valid = true;

                this.errors[type_address].address.valid = onlyLettersAndSpaces(this.form_value[type_address].address) ? true : false;

                this.errors[type_address].house_number.valid = houseNumberCheck(this.form_value[type_address].house_number) ? true : false;

                this.errors[type_address].cap.valid = onlyNumbers(this.form_value[type_address].cap) ? true : false;

                this.errors[type_address].city.valid = onlyLettersAndSpaces(this.form_value[type_address].city) ? true : false;

                this.errors[type_address].district.valid = notEmpty(this.form_value[type_address].district) ? true : false;

                this.errors[type_address].country.valid = (notEmpty(this.form_value[type_address].country) && this.form_value[type_address].country != 0)  ? true : false;

                if(this.form_value[type_address].country != 'Italia' && this.form_value[type_address].country != ''){
                    this.form_value[type_address].district = 'ESTERO';
                }





            }


            this.errors.cf.valid = cfCheck(this.form_value.cf) ? true : false;


            this.errors.prefix.valid = notEmpty(this.form_value.prefix) ? true : false;

            this.errors.phone.valid = onlyNumbers(this.form_value.phone) ? true : false;

            this.errors.email.valid = emailCheck(this.form_value.email) ? true : false;

            this.errors.telegram.valid = telegramCheck(this.form_value.telegram) ? true : false;

            this.errors.politecnico_student.valid = notEmpty(this.form_value.politecnico_student) ? true : false;

            this.errors.personal_code.valid = personalCodeCheck(this.form_value.personal_code) ? true : false;

            this.errors.password.valid = passwordCheck(this.form_value.password) ? true : false;

            this.errors.password2.valid = (this.form_value.password2 === this.form_value.password) ? true : false;



        },

        form_submit(){
            this.first_submit = true;
            //Note: If you enter this function any field with attribute required it's already filled.


            //Check the Field and mark errors
            this.check_form();

            //Check errors state and eventually, send data

            for (error in this.errors){

                if (error == 'permanent_address' || error == 'current_address'){

                    for (error2 in this.errors[error]){
                        if(!this.errors[error][error2].valid){
                            //console.log('Errore: ',error,'->',error2);
                            this.form_not_ok += 1;
                        }else{
                            this.form_not_ok += 0;
                        }
                    }

                    continue;

                }

                if(!this.errors[error].valid){
                    //console.log('Errore: ',error);
                    this.form_not_ok += 1;
                }else{
                    this.form_not_ok += 0;
                }
            }

            //attivare per testare la funzione send senza controllo dei dati!
            //this.form_not_ok = 0; 

            if(this.form_not_ok == 0){

                this.send_data().then((value) => {

                    console.log(value)

                    if (value.user_status == 1){
                        this.success = true;
                        //window.location.href = 'https://membri.poliradio.it/registrazione?success=1';
                    }else{
                        this.auto_compile(value.data,value.err);
                    }

                });

            }else{
                this.form_not_ok = 0;
                return;
            }

        },

        async send_data(){


            var data = this.form_value;

            try {
                let sendData = new FormData();
                Object.keys(data)
                    .filter((item) => item!='permanent_address' && item != 'current_address' && item != '')
                    .forEach((key) => sendData.append(key, data[key]));

                Object.keys(data.current_address).forEach((key) => sendData.append('current_address_'.concat(key), data.current_address[key]));

                Object.keys(data.permanent_address).forEach((key) => sendData.append('permanent_address_'.concat(key), data.permanent_address[key]));

                sendData.append('check','ok');
                //console.log(sendData);

                const response = await fetch(
                    `https://membri.poliradio.it/api/registerValidation.php`,
                    {
                        method: "POST",
                        body: sendData,
                    }
                );

                switch (response.status) {
                    case 403:
                        alert("Permission Denied");
                        break;
                    case 200:
                        return await response.json();
                    default:
                        throw `Unhandled Code ${response.status}`;
                }
            }
            catch (e) {
                console.error(e);
                alert("Internal Error, please reload the page");
            }


        },

    },
    computed : {

    }

});

function notEmpty(str){
    if (str != ''){
        return true;
    }else{
        return false;
    }
}

function onlyLettersAndSpaces(str) {
    str = str.trim();
    //return /^[A-Za-z]+[\sA-Za-z]*[a-z]$/.test(str);
    return /^[a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð,.'-]+[a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð ,.'-]*[a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð,.'-]+$/.test(str);
}

function onlyNumbers(str) {
    return /^[0-9]+$/.test(str);
}

function houseNumberCheck(str) {
    if(/^[0-9]+$/.test(str) || /^[0-9]+[A-Za-z]$/.test(str) || /^[0-9]+[\/\-][A-Za-z0-9]$/.test(str) || str == 'SNC' || str == 'ALTRO'){
        return true;
    }else{
        return false;
    }
}

function birthDateCheck(date){

    if(date == ''){
        return false;
    }

    var birth_date = new Date(date)

    var min_date  = new Date();
    min_date.setFullYear(min_date.getFullYear() - 16);

    var max_date  = new Date();
    max_date.setFullYear(max_date.getFullYear() - 99);

    //console.log(birth_date,min_date,max_date);

    if(birth_date <= min_date && birth_date >= max_date){
        return true;
    }else{
        return false;
    }
}

function cfCheck(str){

    if(/^[A-Z]{6}[0-9]{2}[A-Z]{1}[0-9]{2}[A-Z]{1}[0-9]{3}[A-Z]{1}$/.test(str.toUpperCase())){
        return true;
    }else{
        return false;
    }
}

function emailCheck(str){

    if(/^[a-z.\-0-9]+@[a-z.]+[a-z]+$/.test(str.toLowerCase())){
        return true;
    }else {
        return false;
    }
}

function telegramCheck(str){

    if(/^[a-zA-Z0-9_]+$/.test(str) || /^@[a-zA-Z0-9_]+$/.test(str)){
        return true;
    }else {
        return false;
    }

}

function personalCodeCheck(str){
    if(poliradio_registration.form_value.politecnico_student== '2'){
        poliradio_registration.form_value.personal_code = '';
        return true
    };
    return /^[0-9]{8}$/.test(str);
}

function passwordCheck(str){

    if(str.length < 6){
        return false;
    }

    return true;
}


//Auto Segnalazione Errori se si clicca su .....
//document.querySelector('.form-floating').addEventListener("click" , poliradio_registration.check_form);


function clicktocheck(){
    if(poliradio_registration.first_submit) poliradio_registration.check_form();
}

function presstab(e){
    if(e.code == 'Tab'){
        if(poliradio_registration.first_submit) poliradio_registration.check_form();
    }
}

document.addEventListener("keydown", presstab);
//document.getElementsByTagName('body').addEventListener("click" , clicktocheck);
window.onclick = clicktocheck;
