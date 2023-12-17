package com.example.demo.enums;

import lombok.Getter;

import java.util.ArrayList;
import java.util.List;

@Getter
public enum ContactType {
    PHONE ("Телефон"),
    EMAIL ("Email"),
    TELEGRAM ("Telegram"),
    WHATSAPP ("WhatsApp"),
    TIKTOK("TikTok"),
    INSTAGRAM ("Instagram"),
    FACEBOOK ("Facebook"),
    VK ("ВКонтакте"),
    OK ("Одноклассники"),
    LINKEDIN ("LinkedIn"),
    OTHER ("Другое");

    private final String value;

    ContactType(String value) {
        this.value = value;
    }

    public static List<String> getValuesAsStrings() {
        List<String> valuesAsStrings = new ArrayList<>();
        for (ContactType contactType : ContactType.values()) {
            valuesAsStrings.add(contactType.getValue());
        }
        return valuesAsStrings;
    }
    public static ContactType getByValue(String value) {
        for (ContactType contactType : values()) {
            if (contactType.getValue().equalsIgnoreCase(value)) {
                return contactType;
            }
        }
        throw new IllegalArgumentException("Значение не найдено: " + value);
    }
    public static ContactType getByEnumName(String name) {
        for (ContactType contactType : values()) {
            if (contactType.name().equalsIgnoreCase(name)) {
                return contactType;
            }
        }
        throw new IllegalArgumentException("Значение не найдено: " + name);
    }
}
