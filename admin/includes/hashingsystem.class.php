<?php
class HashingSystem {
	private $salt;
	private $hash;

	public function createHash($password) {
    	$this->salt = base64_encode(mcrypt_create_iv(24, MCRYPT_DEV_URANDOM));
    	$this->hash = base64_encode($this->pbkdf2("sha256", $password, $this->salt, 1000, 24, true));
	}
	
	public function validatePassword($password, $hash, $salt) {
	    return $this->slowEquals(base64_decode($hash), $this->pbkdf2("sha256", $password, $salt, 1000, 24, true));
	}

	public function getHash() {
		return $this->hash;
	}

	public function getSalt() {
		return $this->salt;
	}

	private function slowEquals($a, $b) {
    	$diff = strlen($a) ^ strlen($b);
    	for($i = 0; $i < strlen($a) && $i < strlen($b); $i++) {
       		$diff |= ord($a[$i]) ^ ord($b[$i]);
    	}
    	return $diff === 0;
	}

	private function pbkdf2($algorithm, $password, $salt, $count, $key_length, $raw_output = false) {
	    $algorithm = strtolower($algorithm);
	    if(!in_array($algorithm, hash_algos(), true)) {
	        trigger_error('PBKDF2 ERROR: Invalid hash algorithm.', E_USER_ERROR);
	    }
	    if($count <= 0 || $key_length <= 0) {
	        trigger_error('PBKDF2 ERROR: Invalid parameters.', E_USER_ERROR);
	    }

	    if (function_exists("hash_pbkdf2")) {
	        if (!$raw_output) {
	            $key_length = $key_length * 2;
	        }
	        return hash_pbkdf2($algorithm, $password, $salt, $count, $key_length, $raw_output);
	    }

	    $hash_length = strlen(hash($algorithm, "", true));
	    $block_count = ceil($key_length / $hash_length);

	    $output = "";
	    for($i = 1; $i <= $block_count; $i++) {
	        $last = $salt . pack("N", $i);
	        $last = $xorsum = hash_hmac($algorithm, $last, $password, true);
	        for ($j = 1; $j < $count; $j++) {
	            $xorsum ^= ($last = hash_hmac($algorithm, $last, $password, true));
	        }
	        $output .= $xorsum;
	    }

	    if($raw_output) {
	        return substr($output, 0, $key_length);
	    }
	    else {
	        return bin2hex(substr($output, 0, $key_length));
	    }
	}
}
?>