<?php
class TagActions {
	private $programActions;

	public function __construct($programActions) {
		$this->programActions = $programActions;
		$this->validateProgramActions();
	}

	public function validateProgramActions() {
		if(get_class($this->programActions) != 'ProgramActions') {
			throw new Exception("ProgramActions reference not valid!");			
		}
		if(!$this->programActions->isUserLoggedForRedaction()) {
			$this->programActions->validateCurrentProgram();
		}
	}

	public function creaTag($newTag) {
		if($newTag == '') {
			return;
		}
		$exists = $this->tagExists($newTag, true);
		if($exists) {
			return $exists;
		}
		$check = $this->programActions->isUserLoggedForRedaction();
		$tag = new Tag();
		$tag->tag = $this->parseTag($newTag);
		$tag->created_by = $check ? null : $this->programActions->getCurrentProgram()->id;
		$tag->global = $check ? 1 : 0;
		$tag->used = 1;
		$tag->views = 0;
		$tag->save();
		if($tag->is_invalid()) {
			throw new Exception($tag->errors->full_messages());
		}
		return $tag;
	}

	public function tagExists($tag, $return = false) {
		$exists = Tag::first($tag);
		if($exists) {
			if($return) {
				return $exists;
			}
			return true;
		}
		else {
			return false;
		}
	}

	public function appendTags($tags, $element) {
		if(!is_array($tags)) {
			throw new Exception("Tags deve essere un array!");			
		}
		$type = $this->getTypeOfElement($element);
		foreach($tags as $tag) {
			if($tag != '') {
				$increment = $this->tagExists($tag);
				$tag = $this->creaTag($tag);
				if($type == 'news') {
					$this->makeTagNewsAssociation($tag, $element);
				} elseif($type == 'podcast') {
					$this->makeTagPodcastAssociation($tag, $element);
				}
				$this->addTagToProgram($tag);
				if($increment) {
					$tag->used = $tag->used + 1;
					$tag->save();
				}
			}
		}
		$remove = $this->getTagsToRemove($tags, $element);
		foreach($remove as $r) {
			$this->deleteTagFromElement($r, $element);
		}
		$element->reload();
	}

	private function deleteTagFromElement($tag, $element) {
		if(!$this->tagExists($tag)) {
			return;
		}
		$tag = $this->creaTag($tag);
		$type = $this->getTypeOfElement($element);
		if($type == 'news') {
			$this->deleteTagFromNews($tag, $element);
		} elseif($type == 'podcast') {
			$this->deleteTagFromPodcast($tag, $element);
		}
	}

	private function deleteTagFromNews($tag, $news) {
		$assoc = NewsProgrammiTag::find('first', array('conditions' => array('newsprogrammi_id = ? AND tag = ?', $news->id, $tag->tag)));
		if($assoc) {
			$assoc->delete();
			$tag->used = $tag->used - 1;
			$tag->save();
		}
	}

	private function deleteTagFromPodcast($tag, $podcast) {
		$assoc = PodcastProgrammiTag::find('first', array('conditions' => array('podcastprogrammi_id = ? AND tag = ?', $podcast->id, $tag->tag)));
		if($assoc) {
			$assoc->delete();
			$tag->used = $tag->used - 1;
			$tag->save();
		}
	}

	private function getTagsToRemove($tags, $element) {
		if(!is_array($tags)) {
			throw new Exception("Tags deve essere un array!");			
		}
		$currentTags = $this->getTags($element);
		$remove = array();
		foreach($currentTags as $t) {
			if(!in_array($t, $tags)) {
				$remove[] = $t;
			}
		}
		return $remove;
	}

	private function addTagToProgram($tag) {
		if(!$this->tagExists($tag->tag)){
			return;
		}
		$check = $this->programActions->isUserLoggedForRedaction();
		if($this->tagExistsInProgram($tag)) {
			if($check) {
				$programTag = RedazioneTag::find('first', array('conditions' => array('tag = ?', $tag->tag)));
			}
			else {
				$programTag = ProgrammiTag::find('first', array('conditions' => array('programmi_id = ? AND tag = ?', $this->programActions->getCurrentProgram()->id, $tag->tag)));
			}
			$programTag->used = $programTag->used + 1;
			$programTag->save();
			return;
		}
		if($check) {
			$assoc = new RedazioneTag();
			$assoc->tag = $tag->tag;
			$assoc->used = 0;
			$assoc->save();
		}
		else {
			$assoc = new ProgrammiTag();
			$assoc->programmi_id = $this->programActions->getCurrentProgram()->id;
			$assoc->tag = $tag->tag;
			$assoc->used = 0;
			$assoc->save();
		}
	}

	public function tagExistsInProgram($tag) {
		if($this->programActions->isUserLoggedForRedaction()) {
			$tags = RedazioneTag::all();
		}
		else {
			$tags = $this->programActions->getCurrentProgram()->programmi_tags;
		}
		foreach($tags as $t) {
			if($t->tag == $tag->tag) {
				return true;
			}
		}
		return false;
	}

	private function getTypeOfElement($element) {
		if(get_class($element) == 'NewsProgrammi') {
			return 'news';
		}
		if(get_class($element) == 'PodcastProgrammi') {
			return 'podcast';
		}
		throw new Exception("Invalid type of element!");		
	}

	private function makeTagNewsAssociation($tag, $news) {
		$thisID = $this->programActions->getCurrentProgram() != null ? $this->programActions->getCurrentProgram()->id : null;
		if(!($this->programActions->isUserLoggedForRedaction() && $news->programmi_id == null) && $news->programmi_id != $thisID) {
			throw new Exception("Non hai i permessi per eseguire questa azione!");
		}
		if($this->newsIssetTag($tag, $news)) {
			return;
		}
		$assoc = new NewsProgrammiTag();
		$assoc->newsprogrammi_id = $news->id;
		$assoc->tag = $tag->tag;
		$assoc->save();
		if($assoc->is_invalid()) {
			throw new Exception($assoc->errors->full_messages());
		}
	}

	private function makeTagPodcastAssociation($tag, $podcast) {
		$thisID = $this->programActions->getCurrentProgram() != null ? $this->programActions->getCurrentProgram()->id : null;
		if(!($this->programActions->isUserLoggedForRedaction() && $podcast->programmi_id == null) && $podcast->programmi_id != $thisID) {
			throw new Exception("Non hai i permessi per eseguire questa azione!");
		}
		if($this->podcastIssetTag($tag, $podcast)) {
			return;
		}
		$assoc = new PodcastProgrammiTag();
		$assoc->podcastprogrammi_id = $podcast->id;
		$assoc->tag = $tag->tag;
		$assoc->save();
		if($assoc->is_invalid()) {
			throw new Exception($assoc->errors->full_messages());
		}
	}

	private function newsIssetTag($tag, $news) {
		$tags = $news->news_programmi_tags;
		if(count($tags) >= 5) {
			return true;
		}
		foreach($tags as $t) {
			if($t->tag == $tag->tag) {
				return true;
			}
		}
		return false;
	}

	private function podcastIssetTag($tag, $podcast) {
		$tags = $podcast->podcast_programmi_tags;
		if(count($tags) >= 5) {
			return true;
		}
		foreach($tags as $t) {
			if($t->tag == $tag->tag) {
				return true;
			}
		}
		return false;
	}

	public function parseTag($tag) {
		$tag = strtolower($tag);
		$tag = preg_replace("/[^a-z0-9 ]/i", '', $tag);
		return $tag;
	}

	public function getTags($element) {
		$type = $this->getTypeOfElement($element);
		if($type == 'news') {
			return $this->getNewsTags($element);
		} elseif($type == 'podcast') {
			return $this->getPodcastTags($element);
		}
	}

	private function getNewsTags($news) {
		$tags = $news->news_programmi_tags;
		$return = array();
		foreach($tags as $tag) {
			$return[] = $tag->tag;
		}
		return $return;
	}

	private function getPodcastTags($podcast) {
		$tags = $podcast->podcast_programmi_tags;
		$return = array();
		foreach($tags as $tag) {
			$return[] = $tag->tag;
		}
		return $return;
	}
}
?>