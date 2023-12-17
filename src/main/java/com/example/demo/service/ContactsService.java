package com.example.demo.service;

import com.example.demo.dto.ContactInfoSubmitDto;
import com.example.demo.dto.ContactsDto;
import com.example.demo.dto.SpecialistShortInfoDto;
import com.example.demo.entities.*;
import com.example.demo.enums.ContactType;
import com.example.demo.repository.CategoryRepository;
import com.example.demo.repository.ContactsRepository;
import com.example.demo.repository.ResumeRepository;
import com.example.demo.repository.SpecialistRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class ContactsService {
    private final SpecialistRepository specialistRepository;
    private final ResumeRepository resumeRepository;
    private final CategoryRepository categoryRepository;
    private final SpecialistService specialistService;
    private final ContactsRepository contactsRepository;
    private final UserService userService;

    public List<ContactsDto> getAll() {
        List<Category> categories = categoryRepository.findAll();
        List<Resume> resumes = resumeRepository.findAll();

        List<ContactsDto> list = new ArrayList<>();
        for (Category c : categories) {
            String cc = c.getCategoryName();
            Set<SpecialistShortInfoDto> ss = new HashSet<>();
            Set<Long> specialistIds = new HashSet<>();
            for (Resume r : resumes) {
                if (specialistService.isFullAuthority(r.getSpecialist())) {
                    if (r.getCategory().getCategoryName().equalsIgnoreCase(c.getCategoryName()) && !specialistIds.contains(r.getSpecialist().getId())) {
                        ss.add(SpecialistShortInfoDto.builder()
                                .id(r.getSpecialist().getId())
                                .name(specialistService.findSpecialistName(r.getSpecialist()))
                                .build());
                        specialistIds.add(r.getSpecialist().getId());
                    }
                }
            }
            list.add(ContactsDto.builder()
                    .category(cc)
                    .specialists(new ArrayList<>(ss))
                    .build());
        }
        return list;
    }

    public List<SpecialistShortInfoDto> getSearchResultItems() {
        List<Resume> resumes = resumeRepository.findAll();
        List<Specialist> specialists = specialistRepository.findAll();
        List<SpecialistShortInfoDto> list = new ArrayList<>();
        for (Resume r :
                resumes) {
            if (specialistService.isFullAuthority(r.getSpecialist())) {
                list.add(SpecialistShortInfoDto.builder()
                        .id(r.getSpecialist().getId())
                        .name(r.getName())
                        .build());
                list.add(SpecialistShortInfoDto.builder()
                        .id(r.getSpecialist().getId())
                        .name(r.getResumeDescription())
                        .build());
            }
        }
        for (Specialist s :
                specialists) {
            if (specialistService.isFullAuthority(s)) {
                String name = specialistService.findSpecialistName(s);
                list.add(SpecialistShortInfoDto.builder()
                        .id(s.getId())
                        .name(name)
                        .build());
            }
        }
        return list;
    }

    public List<String> getContactTypeList() {
        return ContactType.getValuesAsStrings();
    }

    public List<ContactInfoSubmitDto> getBusinessCardResume(Long resumeId) {
        var maybeResume = resumeRepository.findById(resumeId);
        if (maybeResume.isPresent()) {
            User user = maybeResume.get().getSpecialist().getUser();
            return getBusinessCardByUser(user);
        }
        return Collections.emptyList();
    }
public List<ContactInfoSubmitDto> getBusinessCardSpecialist(Long specialistId) {
        var maybeSpecialist = specialistRepository.findById(specialistId);
        if(maybeSpecialist.isPresent()) {
            User user = maybeSpecialist.get().getUser();
            return getBusinessCardByUser(user);
        }
    return Collections.emptyList();
}
    public List<ContactInfoSubmitDto> getBusinessCardByUser(User user) {
        List<Contacts> all = contactsRepository.findAllByUser(user);
        List<ContactInfoSubmitDto> list = new ArrayList<>();
        for (Contacts c : all) {
            ContactType type = ContactType.getByEnumName(c.getContactType());
            list.add(ContactInfoSubmitDto.builder()
                    .contactType(type.getValue())
                    .contactValue(c.getContactValue())
                    .build());
        }
        return list;
    }

    public List<ContactInfoSubmitDto> getBusinessCard() {
        User user = userService.getUserFromSecurityContextHolder();
        if (user != null) {
            return getBusinessCardByUser(user);
        }
        return Collections.emptyList();
    }

    public void saveNewContactInfo(List<ContactInfoSubmitDto> contactInfoSubmitDto) {
        User user = userService.getUserFromSecurityContextHolder();
        if (user != null) {
            for (ContactInfoSubmitDto c : contactInfoSubmitDto) {
                ContactType type = ContactType.getByValue(c.getContactType());

                contactsRepository.save(Contacts.builder()
                        .user(user)
                        .contactType(type.toString())
                        .contactValue(c.getContactValue())
                        .build());
            }
        }
    }

    public void deleteContactInfo(String contactType, String contactValue) {
        User user = userService.getUserFromSecurityContextHolder();
        if (user != null) {
            ContactType cT = ContactType.getByValue(contactType);
            List<Contacts> maybeContacts = contactsRepository.findAllByContactTypeAndContactValue(cT.toString(), contactValue);
            if (!maybeContacts.isEmpty()) {
                for (Contacts c : maybeContacts) {
                    if (c.getUser().getId().equals(user.getId())) {
                        contactsRepository.delete(c);
                    }
                }
            }
        }
    }
}
