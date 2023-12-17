package com.example.demo.service;

import com.example.demo.dto.MessageBundleDto;
import com.example.demo.dto.PostShortInfoDto;
import com.example.demo.dto.ResponseDto;
import com.example.demo.dto.ViewerDto;
import com.example.demo.entities.Post;
import com.example.demo.entities.Response;
import com.example.demo.entities.Specialist;
import com.example.demo.repository.PostRepository;
import com.example.demo.repository.ResponseRepository;
import com.example.demo.repository.SpecialistRepository;
import com.example.demo.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
@RequiredArgsConstructor
public class ResponseService {
    private final ResponseRepository responseRepository;
    private final PostRepository postRepository;
    private final SpecialistRepository specialistRepository;
    private final UserRepository userRepository;
    private final SpecialistService specialistService;
    private static final String AUTHOR = "author";
    private static final String READER = "reader";

    public List<PostShortInfoDto> getSpecialistResponses(Long specialistId) {
        List<Response> list = responseRepository.findAllBySpecialistId(specialistId);
        HashSet<Long> set = getUniquePostIds(list);
        return getPostShortInfoList(set);
    }
    private List<PostShortInfoDto> getPostShortInfoList(HashSet<Long> uniquePostIds) {
        List<PostShortInfoDto> result = new ArrayList<>();
        for (Long l : uniquePostIds) {
            var post = postRepository.findById(l);
            if (post.isPresent()) {
                result.add(PostShortInfoDto.builder()
                        .postId(post.get().getId())
                        .postTitle(post.get().getTitle())
                        .build());
            }
        }
        return result;
    }

    public HashSet<Long> getUniquePostIds(List<Response> list) {
        HashSet<Long> set = new HashSet<>();
        for (Response r : list) {
            set.add(r.getPost().getId());
        }
        return set;
    }

    public Response saveResponse(Post post, Specialist specialist, String conversationId, String text) {
        return responseRepository.save(Response.builder()
                .post(post)
                .specialist(specialist)
                .conversationId(conversationId)
                .response(text)
                .dateTime(LocalDateTime.now())
                .build());
    }
    public void deleteAResponse(Long responseId) {
        responseRepository.deleteById(responseId);
    }
    public Response findAResponse(Long id) {
        var response = responseRepository.findById(id);
        if(response.isEmpty()) return null;
        return response.get();
    }
    private String formatDateTimeShort(LocalDateTime dateTime) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM/dd HH:mm");
        return dateTime.format(formatter);
    }
    public List<ResponseDto> getSpecialistConversation(Long postId, ViewerDto v) {
        String conversationId = postId + "-" + v.getSpecialistId();
        List<Response> conversationList = responseRepository.findAllByConversationId(conversationId);

        var specialist = specialistRepository.findById(v.getSpecialistId());
        if (specialist.isEmpty()) return Collections.emptyList();

        var post = postRepository.findById(postId);
        if (post.isEmpty()) return Collections.emptyList();
        return makeResponseDtoList(conversationList);
    }
    public List<ResponseDto> makeResponseDtoList(List<Response> conversationList) {
        List<ResponseDto> list = new ArrayList<>();
        for (Response r : conversationList) {
            String s = (r.getSpecialist() == null) ? READER : AUTHOR;
            list.add(ResponseDto.builder()
                    .response(r.getResponse())
                    .viewer(s)
                    .dateTime(formatDateTimeShort(r.getDateTime()))
                    .build());
        }
        return list;
    }

    public List<ResponseDto> getCustomerMsgByConversation(String conversationId) {
        List<Response> responses = responseRepository.findAllByConversationId(conversationId);
        return makeResponseDtoList(responses);
    }
    public List<ResponseDto> updateMessagesForCustomer(String localDateTime, String conversationId) {
        List<Response> responsesNew = getNew(localDateTime, conversationId);
        List<ResponseDto> list = new ArrayList<>();
        for (Response r :
                responsesNew) {
            if (r.getSpecialist() != null) list.add(ResponseDto.builder()
                    .response(r.getResponse())
                    .viewer(READER)
                    .dateTime(formatDateTimeShort(r.getDateTime()))
                    .build());
        }
        return list;
    }
    private List<Response> getNew(String localDateTime, String conversationId) {
        List<Response> responses = responseRepository.findAllByConversationId(conversationId);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSSX");
        LocalDateTime ldt = LocalDateTime.parse(localDateTime, formatter);

        List<Response> list = new ArrayList<>();
        for (Response r : responses) {
            ZoneId zoneId = ZoneId.of("Asia/Bishkek");
            ZonedDateTime responseDateTime = r.getDateTime().atZone(zoneId);
            ZonedDateTime requestDateTime = ldt.atZone(zoneId).plusHours(6);
            if (requestDateTime.isBefore(responseDateTime)) {
                list.add(r);
            }
        }
        return list;
    }
    public List<ResponseDto> updateMessagesForSpecialist(String localDateTime, String conversationId) {
        List<Response> responsesNew = getNew(localDateTime, conversationId);
        List<ResponseDto> list = new ArrayList<>();
        for (Response r :
                responsesNew) {
            if (r.getUser() != null) list.add(ResponseDto.builder()
                    .response(r.getResponse())
                    .viewer(READER)
                    .dateTime(formatDateTimeShort(r.getDateTime()))
                    .build());
        }
        return list;
    }
    public List<MessageBundleDto> specialistResponses(List<Response> responses, Set<String> filter) {
        List<MessageBundleDto> list = new ArrayList<>();
        responses.sort(Comparator.comparing(Response::getDateTime).reversed());
        for (String s : filter) {
            for (Response r : responses) {
                if (r.getConversationId().equalsIgnoreCase(s) && r.getSpecialist() == null) {
                    list.add(MessageBundleDto.builder()
                            .id("response" + "-" + s)
                            .senderPhoto(r.getUser().getPhoto())
                            .senderName("[стенд] " + r.getUser().getUserName())
                            .lastMessageText(getLastMessageText(responses, s))
                            .lastMessageDateTime(getLastMessageDateTime(responses, s))
                            .build());
                    break;
                }
            }
        }
        return list;
    }
    public List<MessageBundleDto> customerResponses(List<Response> responses, Set<String> filter) {
        List<MessageBundleDto> list = new ArrayList<>();
        responses.sort(Comparator.comparing(Response::getDateTime).reversed());
        for (String s : filter) {
            for (Response r : responses) {
                if (r.getConversationId().equalsIgnoreCase(s) && r.getSpecialist() != null) {
                    var user = userRepository.findById(r.getSpecialist().getUser().getId());
                    if (user.isPresent()) {
                        list.add(MessageBundleDto.builder()
                                .id("response" + "-" + s)
                                .senderPhoto(user.get().getPhoto())
                                .senderName("[стенд] " + specialistService.findSpecialistName(r.getSpecialist()))
                                .lastMessageText(getLastMessageText(responses, s))
                                .lastMessageDateTime(getLastMessageDateTime(responses, s))
                                .build());
                        break;
                    }
                }
            }
        }
        return list;
    }
    private String getLastMessageText(List<Response> responses, String conversationId) {
        return responses.stream()
                .filter(r -> r.getConversationId().equalsIgnoreCase(conversationId))
                .map(Response::getResponse)
                .findFirst()
                .orElse(null);
    }

    private String getLastMessageDateTime(List<Response> responses, String conversationId) {
        LocalDateTime dt = responses.stream()
                .filter(r -> r.getConversationId().equalsIgnoreCase(conversationId))
                .map(Response::getDateTime)
                .findFirst()
                .orElse(null);
        if (dt == null) return null;
        return formatDateTime(dt);
    }
    private String formatDateTime(LocalDateTime dateTime) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM/dd HH:mm");
        return dateTime.format(formatter);
    }

}
