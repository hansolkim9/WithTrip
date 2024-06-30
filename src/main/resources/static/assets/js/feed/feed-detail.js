import {FEED_URL} from "../feed-list.js";
import {renderCarousel, setOneImgStyle} from "../image.js";

function setDetailModal(dto) {
  console.log("디테일모달 업데이트 실행!");
  const {boardId, account, nickname, profileImage, content, createdAt, feedImageList} = dto;

  const $imgCarousel = document.querySelector('.feed-left-side .image-carousel');
  $imgCarousel.innerHTML = '';

  // 프로필 사진 적용
  const $profile = document.querySelector('.feed-right-side .profile-pic');
  $profile.src = profileImage || '/assets/img/mimo.png';

  // 닉네임 적용
  const $nickname = document.querySelector('.feed-right-side .nickname');
  $nickname.textContent = nickname;

  // 날짜 적용
  const $created = document.querySelector('.feed-right-side .created-at');
  $created.textContent = createdAt;

  // content 적용
  const $content = document.querySelector('.detail-content');
  $content.firstElementChild.textContent = content;

  // 상세조회 캐러설에 이미지 추가
  $imgCarousel.innerHTML = renderCarousel(feedImageList, 'post-image d-block w-100', boardId, "Detail");
  setOneImgStyle();

  // 로그인 유저 = 피드 작성자 일때 수정, 삭제 버튼 렌더링

}

// 서버로 boardId 보내서 fetch로 데이터 받아와서 모달에 렌더링
export async function fetchFeedDetail(boardId) {

  const url = `${FEED_URL}/v1/${boardId}`
  const res = await fetch(url);
  if(!res.ok) {
    throw new Error(`HTTP error! Status: ${res.status}`);
  }
  const feedDetailDto = await res.json();
  console.log("피드디테일 fetch 결과:",feedDetailDto);

  setDetailModal(feedDetailDto);

}