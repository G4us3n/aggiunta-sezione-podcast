

<div id="poliradio_registration" class="container">

      <header  class="container py-3">
        <div class="row justify-content-md-center">
          <div class="col-md-auto">
            <h1>{{ show_name.title }}</h1>
          </div>
        </div>

        <nav class="row justify-content-md-center g-2">
          <div class="col-md-auto">
            <button type="button" class="btn" :class="{'btn-success' : language == 'IT' , 'btn-outline-success' : language != 'IT'}" @click="change_language('IT')">Italiano</button>
            <button type="button" class="btn" :class="{'btn-primary' : language == 'EN' , 'btn-outline-primary' : language != 'EN'}"@click="change_language('EN')">English</button>
          </div>
        </nav>

      </header>

      <article v-if=success class="container py-3">
        <p>{{show_name.registration_success_msg}}</p>
      </article>

      <article v-else class="container py-3">

        <form @submit.prevent="form_submit" >

          <!-- Anagrafica -->
          <div class="row g-3">

            <div class="col-md-6">
              <div class="form-floating required">
                <input v-model="form_value.name" type="text" class="form-control" :class="{'is-valid': errors.name.valid === true, 'is-invalid' : errors.name.valid === false}">
                <label class="control-label">{{show_name.name}}</label>
              </div>
            </div>

            <div class="col-md-6">
              <div class="form-floating required">
                <input v-model="form_value.surname" type="text" class="form-control" :class="{'is-valid': errors.surname.valid === true, 'is-invalid' : errors.surname.valid === false}">
                <label class="control-label">{{show_name.surname}}</label>
              </div>
            </div>

            <div class="col-md-6">
              <div class="form-floating">
                <input v-model="form_value.nickname" type="text" class="form-control" :class="{'is-valid': errors.nickname.valid === true, 'is-invalid' : errors.nickname.valid === false}">
                <label class="control-label">{{show_name.nickname}}</label>
              </div>
            </div>

            <div class="col-md-6">
              <div class="form-floating required">
              <select v-model="form_value.gender" class="form-select" :class="{'is-valid': errors.gender.valid === true, 'is-invalid' : errors.gender.valid === false}">
                <option v-for="item in show_name.gender_option" :key="item.gender_id" :value="item.gender_id" > {{ item.gender_value }} </option>
              </select>
              <label class="control-label">{{show_name.gender}}</label>
              </div>
            </div>

            <div class="col-md-3">
              <div class="form-floating required">
                <input v-model="form_value.birth_date" type="date" class="form-control" :class="{'is-valid': errors.birth_date.valid === true, 'is-invalid' : errors.birth_date.valid === false}">
                <label class="control-label">{{show_name.birth_date}}</label>
                <div class="invalid-feedback">
                {{show_name.wrong_feedback.birth_date}}
                </div>
              <!--<div class="valid-feedback">
                {{show_name.right_feedback.birth_date}}
              </div>-->
              </div>
            </div>

            <div class="col-md-4">
              <div class="form-floating required">
                <input v-model="form_value.cf" type="text" class="form-control" :class="{'is-valid': errors.cf.valid === true, 'is-invalid' : errors.cf.valid === false}" maxlength="16">
                <label class="control-label">{{show_name.cf}}</label>
              </div>
            </div>

            <div class="col-md-4">
              <div class="form-floating required">
                <select v-model="form_value.country_birth" class="form-select" :class="{'is-valid': errors.country_birth.valid === true, 'is-invalid' : errors.country_birth.valid === false}">

                    <option v-if="language == 'IT'" value="0">Seleziona uno stato</option>
                    <option v-else value="0">Choose a country</option>

                    <?php foreach($tabella_stati as $row): ?>
                    <option v-if="language == 'IT'" value="<?=$row->nome_stati?>"><?=$row->nome_stati?></option>

                    <option v-else value="<?=$row->nome_stati?>"><?=$row->nome_inglese_stati?></option>
                    <?php endforeach; ?>

                </select>
                <label class="control-label">{{show_name.country_birth}}</label>
              </div>
            </div>

            <div v-if="form_value.country_birth == 'Italia'" class="col-md-6">
              <div class="form-floating required">
              <select v-model="form_value.district_birth" class="form-select" :class="{'is-valid': errors.district_birth.valid === true, 'is-invalid' : errors.district_birth.valid === false}">

                <option value="ESTERO"> {{show_name.district_abroad}}</option>

                <?php foreach($tabella_province as $row): ?>
                  <option value="<?=$row->nome_province?>"><?=$row->nome_province?> (<?=$row->sigla_province?>)</option>
                <?php endforeach; ?>
              </select>
              <label class="control-label">{{show_name.district_birth}}</label>
              </div>
            </div>

            <div class="col-md-5">
              <div class="form-floating required">
                <input v-model="form_value.place_birth" type="text" class="form-control" :class="{'is-valid': errors.place_birth.valid === true, 'is-invalid' : errors.place_birth.valid === false}">
                <label class="control-label">{{show_name.place_birth}}</label>
              </div>
            </div>

          </div>

          <!-- Residenza -->
          <hr>
          {{show_name.permanent_address}}

          <div class="row py-3 g-3">
            <!--
            <div class="col-xxl-1">
              <div class="form-floating required">
                <input v-model="form_value.permanent_address.street" type="text" class="form-control" :class="{'is-valid': errors.permanent_address.street.valid === true, 'is-invalid' : errors.permanent_address.street.valid === false}">
                <label class="control-label">{{show_name.street}}</label>
              </div>
            </div>
            -->
            <div class="col-md-5">
              <div class="form-floating required">
                <input v-model="form_value.permanent_address.address" type="text" class="form-control" :class="{'is-valid': errors.permanent_address.address.valid === true, 'is-invalid' : errors.permanent_address.address.valid === false}">
                <label class="control-label">{{show_name.address}}</label>
              </div>
            </div>

            <div class="col-xxl-1">
              <div class="form-floating required">
                <input v-model="form_value.permanent_address.house_number" type="text" class="form-control" :class="{'is-valid': errors.permanent_address.house_number.valid === true, 'is-invalid' : errors.permanent_address.house_number.valid === false}">
                <label class="control-label">{{show_name.house_number}}</label>
                <div class="invalid-feedback">
                {{show_name.wrong_feedback.house_number}}
                </div>
              </div>
            </div>

            <div class="col-xxl-1">
              <div class="form-floating required">
                <input v-model="form_value.permanent_address.cap" type="text" class="form-control" :class="{'is-valid': errors.permanent_address.cap.valid === true, 'is-invalid' : errors.permanent_address.cap.valid === false}">
                <label class="control-label">{{show_name.cap}}</label>
              </div>
            </div>

            <div class="col-md-3">
              <div class="form-floating required">
                <select v-model="form_value.permanent_address.country" class="form-select" :class="{'is-valid': errors.permanent_address.country.valid === true, 'is-invalid' : errors.permanent_address.country.valid === false}">
                    <option v-if="language == 'IT'" value="0">Seleziona uno stato</option>
                    <option v-else value="0">Choose a country</option>

                    <?php foreach($tabella_stati as $row): ?>
                    <option v-if="language == 'IT'" value="<?=$row->nome_stati?>"><?=$row->nome_stati?></option>

                    <option v-else value="<?=$row->nome_stati?>"><?=$row->nome_inglese_stati?></option>
                    <?php endforeach; ?>
                </select>

                <label class="control-label">{{show_name.country}}</label>
              </div>
            </div>



            <div v-if="form_value.permanent_address.country == 'Italia'" class="col-md-6">
              <div class="form-floating required">
              <select v-model="form_value.permanent_address.district" class="form-select" :class="{'is-valid': errors.permanent_address.district.valid === true, 'is-invalid' : errors.permanent_address.district.valid === false}">
                <option value="ESTERO"> {{show_name.district_abroad}}</option>

                <?php foreach($tabella_province as $row): ?>
                  <option value="<?=$row->nome_province?>"><?=$row->nome_province?> (<?=$row->sigla_province?>)</option>
                <?php endforeach; ?>
              </select>
              <label class="control-label">{{show_name.district}}</label>
              </div>
            </div>

            <div class="col-md-3">
              <div class="form-floating required">
                <input v-model="form_value.permanent_address.city" type="text" class="form-control" :class="{'is-valid': errors.permanent_address.city.valid === true, 'is-invalid' : errors.permanent_address.city.valid === false}">
                <label class="control-label">{{show_name.city}}</label>
              </div>
            </div>




          </div>

          <!-- Domicilio -->
          <hr>
          {{show_name.current_address}}

          <button type="button" class="btn btn-success" @click="copy_permanent_address">{{show_name.copy_permanent_address}}</button>


          <div class="row py-3 g-3">
            <!--
            <div class="col-xxl-1">
              <div class="form-floating required">
                <input v-model="form_value.current_address.street" type="text" class="form-control" :class="{'is-valid': errors.current_address.street.valid === true, 'is-invalid' : errors.current_address.street.valid === false}">
                <label class="control-label">{{show_name.street}}</label>
              </div>
            </div>
            -->
            <div class="col-md-5">
              <div class="form-floating required">
                <input v-model="form_value.current_address.address" type="text" class="form-control" :class="{'is-valid': errors.current_address.address.valid === true, 'is-invalid' : errors.current_address.address.valid === false}">
                <label class="control-label">{{show_name.address}}</label>
              </div>
            </div>

            <div class="col-xxl-1">
              <div class="form-floating required">
                <input v-model="form_value.current_address.house_number" type="text" class="form-control" :class="{'is-valid': errors.current_address.house_number.valid === true, 'is-invalid' : errors.current_address.house_number.valid === false}">
                <label class="control-label">{{show_name.house_number}}</label>
              </div>
            </div>

            <div class="col-xxl-1">
              <div class="form-floating required">
                <input v-model="form_value.current_address.cap" type="text" class="form-control" :class="{'is-valid': errors.current_address.cap.valid === true, 'is-invalid' : errors.current_address.cap.valid === false}">
                <label class="control-label">{{show_name.cap}}</label>
              </div>
            </div>

            <div class="col-md-3">
              <div class="form-floating required">
                <select v-model="form_value.current_address.country" class="form-select" :class="{'is-valid': errors.current_address.country.valid === true, 'is-invalid' : errors.current_address.country.valid === false}">
                    <option v-if="language == 'IT'" value="0">Seleziona uno stato</option>
                    <option v-else value="0">Choose a country</option>

                    <?php foreach($tabella_stati as $row): ?>
                    <option v-if="language == 'IT'" value="<?=$row->nome_stati?>"><?=$row->nome_stati?></option>

                    <option v-else value="<?=$row->nome_stati?>"><?=$row->nome_inglese_stati?></option>
                    <?php endforeach; ?>
                </select>

                <label class="control-label">{{show_name.country}}</label>
              </div>
            </div>


            <div v-if="form_value.current_address.country == 'Italia'" class="col-md-6">
              <div class="form-floating required">
              <select v-model="form_value.current_address.district" class="form-select" :class="{'is-valid': errors.current_address.district.valid === true, 'is-invalid' : errors.current_address.district.valid === false}">
                <option value="ESTERO"> {{show_name.district_abroad}}</option>

                <?php foreach($tabella_province as $row): ?>
                  <option value="<?=$row->nome_province?>"><?=$row->nome_province?> (<?=$row->sigla_province?>)</option>
                <?php endforeach; ?>
              </select>
              <label class="control-label">{{show_name.district}}</label>
              </div>
            </div>

             <div class="col-md-3">
              <div class="form-floating required">
                <input v-model="form_value.current_address.city" type="text" class="form-control" :class="{'is-valid': errors.current_address.city.valid === true, 'is-invalid' : errors.current_address.city.valid === false}">
                <label class="control-label">{{show_name.city}}</label>
              </div>
            </div>


          </div>


          <!-- Contact -->
          <hr>
          <div class="row py-3 g-3">

            <div class="col-lg-2">
              <div class="form-floating required">

                <select v-model="form_value.prefix" class="form-select"  :class="{'is-valid': errors.prefix.valid === true, 'is-invalid' : errors.prefix.valid === false}">
                    <option v-if="language == 'IT'" value="39" selected> +39 (Italia)</option>
                    <option v-else value="39" selected> +39 (Italy)</option>

                    <?php foreach($tabella_stati as $row): ?>
                    <option v-if="language == 'IT'" value="<?=substr($row->prefisso_telefonico_stati,1)?>"><?=$row->prefisso_telefonico_stati?> (<?=$row->nome_stati?>)</option>

                    <option v-else value="<?=substr($row->prefisso_telefonico_stati,1)?>"><?=$row->prefisso_telefonico_stati?> (<?=$row->nome_inglese_stati?>)</option>
                    <?php endforeach; ?>
                </select>


                <label class="control-label">{{show_name.prefix}}</label>
              </div>
            </div>

            <div class="col-md-3">
              <div class="form-floating required">
                <input v-model="form_value.phone" type="text" class="form-control" :class="{'is-valid': errors.phone.valid === true, 'is-invalid' : errors.phone.valid === false}">
                <label class="control-label">{{show_name.phone}}</label>
              </div>
            </div>

            <div class="col-md-4">
              <div class="form-floating required">
                <input v-model="form_value.email" type="text" class="form-control" :class="{'is-valid': errors.email.valid === true, 'is-invalid' : errors.email.valid === false}">
                <label class="control-label">{{show_name.email}}</label>
              </div>
            </div>

            <div class="col-md-3">
              <div class="form-floating required">
                <input v-model="form_value.telegram" type="text" class="form-control" :class="{'is-valid': errors.telegram.valid === true, 'is-invalid' : errors.telegram.valid === false}">
                <label class="control-label">{{show_name.telegram}}</label>
                <div class="invalid-feedback">
                  {{show_name.wrong_feedback.telegram}}
                </div>
              </div>
            </div>

          </div>

          <!-- Politecnico -->
          <div class="row py-3 g-3">

            <div class="col-md-6">
              <div class="form-floating required">
                <select v-model="form_value.politecnico_student" class="form-select" :class="{'is-valid': errors.politecnico_student.valid === true, 'is-invalid' : errors.politecnico_student.valid === false}" >
                  <option v-for="item in show_name.politecnico_student_option" :key="item.politecnico_student_id" :value="item.politecnico_student_id"> {{item.politecnico_student_value}} </option>
                </select>
                <label class="control-label">{{show_name.politecnico_student}}</label>
              </div>
            </div>

            <div class="col-md-4" v-if="form_value.politecnico_student != 2">
              <div class="form-floating">
                <input v-model="form_value.personal_code" type="text" class="form-control" :class="{'is-valid': errors.personal_code.valid === true, 'is-invalid' : errors.personal_code.valid === false}">
                <label class="control-label">{{show_name.personal_code}}</label>
              </div>
            </div>

          </div>

          <!-- Password -->
          <hr>
          <div class="row py-3 g-3">

            <div class="col-md-4">
              <div class="form-floating required">
                <input v-model="form_value.password" type="password" class="form-control" :class="{'is-valid': errors.password.valid === true, 'is-invalid' : errors.password.valid === false}" >
                <label class="control-label">{{show_name.password}}</label>
                <div class="invalid-feedback">
                  {{show_name.wrong_feedback.telegram}}
                </div>
              </div>
            </div>

            <div class="col-md-4">
              <div class="form-floating required">
                <input v-model="form_value.password2" type="password" class="form-control" :class="{'is-valid': errors.password2.valid === true, 'is-invalid' : errors.password2.valid === false}">
                <label class="control-label">{{show_name.password2}}</label>
              </div>
            </div>

          </div>

          <button class="btn btn-primary" type="submit"> Invia</button>


        </form>
      </article>



    </div>
